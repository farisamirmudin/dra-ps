# About
A powershell script that allows watching kdrama using the terminal
## Install
IMPORTANT! Powershell 7, git, fzf and mpv/iina are required for the program to run. Installations [(See below)](#Recommended-Installation).
- Windows
  ```sh
  git clone https://github.com/farisamirmudin/dra-ps.git
  ```
  Then go into the dra-ps folder and double click the run.bat file.
- MacOS
  Execute the following command.
  ```sh
  git clone https://github.com/farisamirmudin/dra-ps.git && cd ./dra-ps
  cp cli.ps1 "$(brew --prefix)"/bin 
  ```
  Then enter cli.ps1 in the Terminal to run the program.
- Linux
  Execute the following command.
  ```sh
  git clone https://github.com/farisamirmudin/dra-ps.git && cd ./dra-ps
  cp cli.ps1 /usr/local/bin
  ```
  Then enter cli.ps1 in the Terminal to run the program.
  
## Dependencies

- Powershell 7  
- git
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
  scoop install git
  scoop install fzf
  scoop install mpv
  ```
- MacOS  
  - Homebrew, powershell, fzf and iina.
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install --cask powershell
  brew install git
  brew install fzf
  brew install --cask iina
  ```



