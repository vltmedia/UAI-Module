# UAI Module

**UAI Module** is a versatile .NET 8.0 C# pipeline developed by UAI Software Inc. that enables users to generate a DLL, CLI, GUI, and MSI Installer within the same project. This repository aims to streamline the process of building, deploying, and distributing modules with multiple user interface options, making it suitable for a variety of applications and deployment environments.

---

## Features

- **DLL Generation**: Easily generate reusable DLLs to integrate with other .NET projects.
- **Command-Line Interface (CLI)**: Create a CLI version for command-line usage, perfect for automation and scripting.
- **Graphical User Interface (GUI)**: Develop a user-friendly GUI application using .NET's Windows Presentation Foundation (WPF).
- **MSI Installer**: Generate a Windows Installer (MSI) package to facilitate easy installation on Windows systems.

## Getting Started

### Prerequisites

- [.NET 8.0 SDK](https://dotnet.microsoft.com/download/dotnet/8.0)
- Windows OS (for MSI creation and GUI development)
- Visual Studio for enhanced development experience
- Git LFS (Large File Storage) for managing large files

### Installation

1. **Clone the Repository**
  
  ```bash
  git clone https://github.com/UAISoftwareInc/UAI-Module.git
  cd UAI-Module
  git lfs fetch --all
  ```
  
2. **Restore NuGet Packages**
  
  ```bash
  dotnet restore
  ```
  
3. **Build the Solution**
  
  ```bash
  dotnet build
  ```
  

### Build Commands
You can always just build from Visual Studio since thats recommended to not screw things up. But if you want to build from the command line, here are the commands.

- **Generate DLL**
  
  ```bash
  dotnet publish -c Release -o ./dist/dll
  ```
  
- **Generate CLI Application**
  
  ```bash
  dotnet publish -c Release -o ./outdistut/cli
  ```
  
- **Generate GUI Application**
  
  ```bash
  dotnet publish -c Release -p:UseWPF=true -o ./dist/gui
  ```
  
- **Generate MSI Installer**
  
  - To build the MSI, you will need to use a packaging tool like [WiX Toolset](https://wixtoolset.org/) or Visual Studio Installer Projects.
  - Ensure the MSI project references your main executable, and then build using:
    
    ```bash
    msbuild /p:Configuration=Release ./dist/installer/UAI_ModuleInstaller.wixproj
    ```
    

## Project Structure

- `./` - Contains the main codebase for DLL, CLI, and GUI versions.
- `dist/` - Build artifacts are saved here, separated into `dll`, `cli`, `gui`, and `installer`.

## License

This project is licensed under the Apache 2.0 License. See the [LICENSE](Module/License.md) file for details.

## Support

For support, please open an issue or contact info@uai.contact.

---

*By UAI Software Inc.*