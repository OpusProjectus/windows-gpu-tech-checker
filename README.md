# Windows Graphics API & Upscaling Tech Checker

This PowerShell script is a straightforward tool designed to quickly determine which graphics API (like DirectX or Vulkan) and upscaling technologies (such as NVIDIA DLSS, AMD FSR, or Intel XeSS) a specific running Windows process, typically a game, is utilizing.

It's particularly useful for checking if a game is using DirectX 11, DirectX 12, Vulkan, or if it has integrated support for modern upscaling solutions like DLSS, FSR, or XeSS.

## How to Use

1.  **Save the script:** Save the provided PowerShell code as a `.ps1` file (e.g., `check_gpu_tech.ps1`).

2.  **Run as Administrator:** The script requires administrative privileges to inspect other running processes. Open PowerShell or Windows Terminal as an administrator.

3.  **Navigate and Execute:**

    * Use the `cd` command to navigate to the directory where you saved the script.

    * Run the script by typing `.\check_gpu_tech.ps1` and pressing Enter.

**Important:** The target process name (e.g., "Bodycam-Win64-Shipping") and specific instructions for modifying it are located directly within the `check_gpu_tech.ps1` file itself as variables. Please open the script file to adjust these settings as needed.

## What It Checks For

The script identifies the presence of key DLLs (Dynamic Link Libraries) associated with:

* **Graphics APIs:** DirectX (d3d11.dll, d3d12.dll) and Vulkan (various vulkan-related DLLs).

* **Upscaling Technologies:**

    * NVIDIA DLSS (nvngx_dlss.dll)

    * AMD FidelityFX/FSR (e.g., `amd_fidelityfx_x.dll`, `amd_fsr_x.dll`)

    * Intel XeSS (libxess.dll)

**Note:** The detection of a DLL indicates *integrated support* for the technology within the application. It does not necessarily mean the feature is *currently active*. Activation is typically managed through the application's in-game or program settings.

## License

This project is licensed under the [GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.html).

**Please be aware:** While GPLv3 allows for free distribution, the *non-commercial sale* of this specific tool is not intended by the creator. If you have commercial use in mind, please reach out to the creator.
