# About
A powershell script that allows watching kdrama using the terminal
## First Run
IMPORTANT! Powershell 7, fzf and mpv/iina are required for the program to run. Installations [(See below)](#Recommended-Installation). Run the program by double clicking the `run.bat` file (for windows) or by executing the following commands (for MacOS or Linux).
```sh
  sudo rm /usr/local/dra-ps
  sudo cp 
  ```
## Dependencies

- Powershell 7  
- fzf  
- mpv (Windows)
- iina (MacOS)  

## Recommended Installation

Installing dependecies using package manager ([Scoop](https://scoop.sh/) for windows, [Homebrew](https://brew.sh/) for MacOS) is strongly recommended. This eases the process of the installation and saves so much time. Open powershell and enter the following commands line by line and press enter.

- Windows
  - Powershell 7 can be installed from Microsoft Store or using the following commands. Source [docs.microsoft.com](https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2)
  ```sh
  winget search Microsoft.PowerShell
  winget install --id Microsoft.Powershell --source winget
  ```
  - Scoop
  ```sh
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  irm get.scoop.sh | iex
  scoop install fzf
  scoop install mpv
  ```
- MacOS  
  - Homebrew, powershell, fzf and iina.
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install --cask powershell
  brew install fzf
  brew install --cask iina
  ```



