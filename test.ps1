$Data = Get-Content -Path $PSScriptRoot\cipher.json | ConvertFrom-Json
$Data.key | Get-Member
[byte[]] $key = $Data.key.split(',')
$key