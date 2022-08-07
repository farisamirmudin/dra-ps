# About
A powershell script that allows watching korean drama using the terminal
## Install
IMPORTANT! Powershell 7, git, fzf and mpv/iina are required for the program to run. Installations [(See below)](#Recommended-Installation). After the dependencies are installed, open powershell/cmd/terminal and enter the following commands.
```sh
cd ./Downloads/
git clone https://github.com/farisamirmudin/dra-ps.git
```
Then go to the dra-ps folder, double click on the run_cli.bat file in windows folder or run_cli file in linux_darwin folder to run the program.
  
## Dependencies

- Powershell 7  
- git
- fzf  
- mpv (Windows)
- iina (MacOS)  

## Recommended Installation

RECOMMENDED! Use a package manager ([Scoop](https://scoop.sh/) for windows, [Homebrew](https://brew.sh/) for MacOS) to install the required dependecies. This eases the process of the installation and saves so much time. Open powershell/cmd/terminal and enter the following commands line by line and press enter.

- Windows
  - Installation of Scoop, powershell 7, git, fzf, mpv
  ```sh
  Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
  irm get.scoop.sh | iex
  scoop install git
  scoop bucket add extras
  scoop install pwsh
  scoop install fzf
  scoop install mpv
  ```
- MacOS  
  - Installation of Homebrew, powershell 7, git, fzf and iina.
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install --cask powershell
  brew install git
  brew install fzf
  brew install --cask iina
  ```
- Linux 
  - Installation of powershell 7 [(Source)](https://docs.microsoft.com/de-de/powershell/scripting/install/install-ubuntu?view=powershell-7.2), git, fzf and mpv.
  ```sh
  curl -0 https://github.com/PowerShell/PowerShell/releases/download/v7.2.4/powershell-lts_7.2.4-1.deb_amd64.deb
  sudo dpkg -i powershell-lts_7.2.4-1.deb_amd64.deb
  sudo apt-get install -f
  sudo apt install git-all
  sudo apt install fzf
  sudo apt install mpv
  ```
Restart your computer to avoid errors.



