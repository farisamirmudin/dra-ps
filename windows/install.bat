Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
irm get.scoop.sh | iex
scoop install git
scoop bucket add extras
scoop install pwsh
scoop install fzf
scoop install mpv