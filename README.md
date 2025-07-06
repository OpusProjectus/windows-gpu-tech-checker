# Windows Graphics API & Upscaling Tech Checker

This PowerShell script is a straightforward tool designed to quickly determine which graphics API (like [DirectX](https://learn.microsoft.com/en-us/windows/win32/directx) or [Vulkan](https://www.vulkan.org/)) and upscaling technologies (such as [NVIDIA DLSS](https://en.wikipedia.org/wiki/Deep_Learning_Super_Sampling), [AMD FSR](https://en.wikipedia.org/wiki/GPUOpen#FidelityFX_Super_Resolution), or [Intel XeSS](https://www.intel.com/content/www/us/en/support/articles/000090031/graphics/intel-arc-dedicated-graphics-family.html#:~:text=XeSS%20or%20Xe%20Super%20Sampling,performance%20and%20high%2Dfidelity%20visuals.)) a specific running Windows process, typically a game, is utilizing.

It's particularly useful for checking if a game is using DirectX 11, DirectX 12, Vulkan, or if it has integrated support for modern upscaling solutions like DLSS, FSR, or XeSS.

## Before you continue
#### Recommendations 

1. **Update powershell to the latest version, you can do this through [Microsoft Store](https://apps.microsoft.com/detail/9mz1snwt0n5d?hl=en-US&gl=US) or Windows Update.

2. **Update your graphic card drivers and make sure you have [DirectX](https://www.microsoft.com/en-us/download/details.aspx?id=35) installed in order to get the truth and avoid misleading results

## How to Use

1.  **[Save the script](https://github.com/sparklineflux/windows-gpu-tech-checker/blob/CMD/cgpuapi-win.v1.0.0.ps1):** Save the PowerShell script/code as a `.ps1` file (e.g., `cgpuapi-win.v1.0.0.ps1`).

2.  **Run as Administrator:** The script requires administrative privileges to inspect other running processes. Open PowerShell or Windows Terminal as an administrator.

3.  **Navigate and Execute:**

    * Use the `cd` command to navigate to the directory where you saved the script.

    * Run the script by typing `.\cgpuapi-win.v1.0.0.ps1` and pressing Enter.

**Important:** 
You will be able to enter a process of your choice (e.g., `ezquake`, `wow`, `bodycam`) by running [cgpuapi-win.v1.0.0.ps1](https://github.com/sparklineflux/windows-gpu-tech-checker/blob/CMD/cgpuapi-win.v1.0.0.ps1).
Easiest way's simply reading the instructions from the prompt explaining and accepting input which allows you to run it, as-is, or by changing the default example variable are located directly within the ps1 script file itself. 

**To do the latter** simply download and open the file in any text-edior. I recommend `notepad++`, `vim` or `aetherlink`, but notepad will do. Now adjust the settings as needed. 

**Remember that you risk making unwanted changes**; 
I'm not recommending this method for users wholly new to writing or handling code!


Below I've presented a example of my own interaction with the script, including the output (On a Windows 11 Pro with Powershell 7.5.2) while running [ezquake](https://nquake.com/) in the background.
I didn't enter any input, it will use your userprofile folder `Documenets` as default and give the filename a date- and time reference in the filename.

```
   Process 'ezquake' (ID: 372) found. Attempting to list modules...
   Searching for relevant DLLs...
   - Found DirectX DLL: d3d12.dll

   --- Summary of Detected Technologies ---
   [API] Likely DirectX.
   [Upscaling] No AMD FSR found.
   [Upscaling] No NVIDIA DLSS found.
   [Upscaling] No Intel XeSS found.

   Note: A loaded DLL indicates support, not necessarily active use.
   Do you want to save a log of the results? (y/n): y
   Enter log file path (default: C:\Users\opusprojectus\Documents\GPU_TechCheck_2025-07-06_20-31-46.log.txt)
   Log file path: 
   Save to 'C:\Users\opusprojectus\Documents\GPU_TechCheck_2025-07-06_20-31-46.log.txt'? (y/n): y
```

# What It Checks For

The script identifies the presence of key DLLs (Dynamic Link Libraries) associated with:

* **Graphics APIs:** DirectX (d3d11.dll, d3d12.dll) and Vulkan (various vulkan-related DLLs).

* **Upscaling Technologies:**

    * NVIDIA DLSS (nvngx_dlss.dll)

    * AMD FidelityFX/FSR (e.g., `amd_fidelityfx_x.dll`, `amd_fsr_x.dll`)

    * Intel XeSS (libxess.dll)

**Note:** The detection of a DLL indicates *integrated support* for the technology within the application. It does not necessarily mean the feature is *currently active*. Activation is typically managed through the application's in-game or program settings.

# License

This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

**Please be aware:** While GPLv3 allows for free distribution, the *non-commercial sale* of this specific tool is not intended by the creator. If you have commercial use in mind, please reach out to the creator.
