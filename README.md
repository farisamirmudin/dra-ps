# About
A powershell script that allows watching kdrama using the terminal
## Install
IMPORTANT! Powershell 7, git, fzf and mpv/iina are required for the program to run. Installations [(See below)](#Recommended-Installation). Open powershell/cmd/terminal and enter `cd ./Downloads/` followed by the following commands.
- Windows
  ```sh
  git clone https://github.com/farisamirmudin/dra-ps.git
  ```
  Then go into the dra-ps folder and double click the run.bat file.
- MacOS
  ```sh
  git clone https://github.com/farisamirmudin/dra-ps.git && cd ./dra-ps
  cp cli.ps1 "$(brew --prefix)"/bin 
  ```
  Then enter `pwsh cli.ps1` in the Terminal to run the program.
- Linux
  ```sh
  git clone https://github.com/farisamirmudin/dra-ps.git && cd ./dra-ps
  cp cli.ps1 /usr/local/bin
  ```
  Then enter `pwsh cli.ps1` in the Terminal to run the program.
  
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
  - Installation of Homebrew, powershell7, git, fzf and iina.
  ```sh
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install --cask powershell
  brew install git
  brew install fzf
  brew install --cask iina
  ```



