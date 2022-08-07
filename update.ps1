Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/farisamirmudin/dra-ps/main/cli.ps1' -OutFile .\cli.ps1.tmp
$updated = Compare-Object (Get-Content .\cli.ps1) (Get-Content .\cli.ps1.tmp)
if ($updated) {
    Write-Host 'New Changes Available. Updating...'
    Remove-Item -Path '.\cli.ps1'
    Rename-Item -Path '.\cli.ps1.tmp' -NewName '.\cli.ps1'
    
} else {
    Write-Host 'No New Changes.'
}