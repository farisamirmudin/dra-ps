# About
A Powershell script that allows watching kdrama using the terminal
## First Run
To be able to run this script for the first time, open powershell and enter following command.
```sh
Set-ExecutionPolicy RemoteSigned
```
## Dependencies

- fzf  
- mpv  

### Recommended Installation

Installing dependecies using [scoop package manager](https://scoop.sh/) is strongly recommended. This eases the process of the installation and saves so much time. Again open powershell and enter the following commands line by line and press enter.

- Scoop
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



