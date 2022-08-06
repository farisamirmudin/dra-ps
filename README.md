# About
A powershell script that allows watching kdrama using the terminal
## First Run
Open powershell and enter following command. This command is to allow the execution of remote script. Noted, powershell 7, fzf and mpv are required for the program to run. Installations are given [below](#Recommended-Installation).
```sh
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
```
## Dependencies

- Powershell 7  
- fzf  
- mpv  

## Recommended Installation

Installing dependecies using [scoop package manager](https://scoop.sh/) is strongly recommended. This eases the process of the installation and saves so much time. Again open powershell and enter the following commands line by line and press enter.

- Windows
  - Powershell 7 can be installed from Microsoft Store or using the following command. Source [docs.microsoft.com](https://docs.microsoft.com/de-de/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.2)
  ```sh
  winget search Microsoft.PowerShell # To check available version
  winget install --id Microsoft.Powershell --source winget # Installation
  ```
  - Scoop # Install scoop
  ```sh
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
  irm get.scoop.sh | iex
  ```
  - fzf
  ```sh
  scoop bucket add main
  scoop install fzf
  ```
  - mpv
  ```sh
  scoop bucket add extras
  scoop install mpv
  ```
- MacOS
  Again, similar to scoop package manager, [homebrew](https://brew.sh/) package manager can be used to install the dependencies. Enter the following commands in the Terminal.
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" # To install homebrew
  brew install --cask powershell # To install powershell 7
  brew install fzf # To install fzf
  brew install --cask iina # To install iina media player, recommended for mac user
  ```



