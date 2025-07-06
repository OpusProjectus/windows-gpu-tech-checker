param (
    [string]$ProcessName = "ezquake"
)

# Requires PowerShell to be run as Administrator
Set-StrictMode -Version Latest


# --- Function: Get process by name or ID ---
function Get-TargetProcess {
	param ( [string]$NameOrId )

    if ($NameOrId -match "^\d+$") {
        try {
            return Get-Process -Id ([int]$NameOrId) -ErrorAction Stop
        } catch {}
    }

    try {
        return Get-Process -Name $NameOrId -ErrorAction Stop
    } catch {
        return $null
    }
}

# --- Function: Analyze loaded modules for GPU tech ---
function Get-GpuTechReportContent {
    param ([System.Diagnostics.Process]$ProcessObject)

    $reportLines = @()
    $foundVulkan = $false
    $foundDX = $false
    $foundFSR = $false
    $foundDLSS = $false
    $foundXeSS = $false

    try {
        $modules = Get-Process -Id $ProcessObject.Id -Module -ErrorAction Stop
        $reportLines += "Searching for relevant DLLs..."

        foreach ($module in $modules) {
            $name = $module.ModuleName.ToLower()

            if ($name -like "*vulkan*") {
                $reportLines += "- Found Vulkan DLL: $($module.ModuleName)"
                $foundVulkan = $true
            }
            if ($name -eq "d3d11.dll" -or $name -eq "d3d12.dll") {
                $reportLines += "- Found DirectX DLL: $($module.ModuleName)"
                $foundDX = $true
            }
            if ($name -like "*amd_fidelityfx*" -or $name -like "*amd_fsr*") {
                $reportLines += "- Found AMD FidelityFX/FSR DLL: $($module.ModuleName)"
                $foundFSR = $true
            }
            if ($name -eq "nvngx_dlss.dll") {
                $reportLines += "- Found NVIDIA DLSS DLL: $($module.ModuleName)"
                $foundDLSS = $true
            }
            if ($name -eq "libxess.dll") {
                $reportLines += "- Found Intel XeSS DLL: $($module.ModuleName)"
                $foundXeSS = $true
            }
        }

        $reportLines += "`n--- Summary of Detected Technologies ---"
        if ($foundVulkan) { $reportLines += "[API] Likely Vulkan." }
        elseif ($foundDX) { $reportLines += "[API] Likely DirectX." }
        else { $reportLines += "[API] Could not determine from common DLLs." }

        $reportLines += if ($foundFSR) { "[Upscaling] AMD FidelityFX/FSR detected." } else { "[Upscaling] No AMD FSR found." }
        $reportLines += if ($foundDLSS) { "[Upscaling] NVIDIA DLSS detected." } else { "[Upscaling] No NVIDIA DLSS found." }
        $reportLines += if ($foundXeSS) { "[Upscaling] Intel XeSS detected." } else { "[Upscaling] No Intel XeSS found." }

        $reportLines += "`nNote: A loaded DLL indicates support, not necessarily active use."
    } catch {
        $reportLines += "WARNING: Could not retrieve modules. Are you running PowerShell as Administrator?"
        $reportLines += "ERROR: $($_.Exception.Message)"
    }

    return $reportLines
}

# --- Main Logic ---
$processFound = $false
$retryCount = 0
$maxRetries = 3
$reportContent = @()

while (-not $processFound -and $retryCount -lt $maxRetries) {
    $process = Get-TargetProcess -NameOrId $ProcessName

    if ($process) {
        $reportContent += "Process '$($process.ProcessName)' (ID: $($process.Id)) found. Attempting to list modules..."
        $processFound = $true
    } else {
        $reportContent += "Process '$ProcessName' was not found."
        $reportContent += ""
        $reportContent += "--- How to find a process name or ID ---"
        $reportContent += "1. Open Task Manager (Ctrl+Shift+Esc)."
        $reportContent += "2. Go to the 'Details' tab."
        $reportContent += "3. Use the 'Name' (e.g., 'Game') or PID (e.g., 1234)."
        $reportContent += "4. Or run: Get-Process | Select-Object ProcessName, Id"
        $reportContent += ""

        $reportContent | ForEach-Object { Write-Host $_ }
        $reportContent = @()

        $userInput = Read-Host "Enter a new process name or PID (or press Enter to retry, or type 'exit' to quit)"

        if ($userInput -eq "exit") {
            Write-Host "Exiting script." -ForegroundColor Yellow
            return
        } elseif ($userInput) {
            $ProcessName = $userInput
        } else {
            $retryCount++
            if ($retryCount -ge $maxRetries) {
                Write-Host "Maximum retries reached. Exiting." -ForegroundColor Red
                return
            }
            Write-Host "Retrying..." -ForegroundColor Yellow
        }
    }
}

if ($process) {
    $reportContent += Get-GpuTechReportContent -ProcessObject $process
    $reportContent | ForEach-Object { Write-Host $_ }

    $saveLog = Read-Host "Do you want to save a log of the results? (y/n)"
    if ($saveLog -match "^[yY](es)?$") {
        $defaultPath = "$env:USERPROFILE\Documents"
        $fileName = "GPU_TechCheck_$(Get-Date -Format 'yyyy-MM-dd_HH-mm-ss').log.txt"
        $suggestedPath = Join-Path $defaultPath $fileName

        Write-Host "Enter log file path (default: $suggestedPath)"
        $logFilePath = Read-Host "Log file path"

        if (-not $logFilePath) {
            $logFilePath = $suggestedPath
        }

        $confirm = Read-Host "Save to '$logFilePath'? (y/n)"
        if ($confirm -match "^[yY](es)?$") {
            try {
                $dir = Split-Path $logFilePath -Parent
                if (-not (Test-Path $dir)) {
                    New-Item -ItemType Directory -Path $dir -Force | Out-Null
                }
                $reportContent | Out-File -FilePath $logFilePath -Encoding UTF8 -Force
                Write-Host "Log saved to '$logFilePath'." -ForegroundColor Green
            } catch {
                Write-Warning "Failed to save log: $($_.Exception.Message)"
            }
        } else {
            Write-Host "Log save cancelled." -ForegroundColor Yellow
        }
    }
}
