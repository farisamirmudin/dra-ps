$ProgressPreference = 'Continue'
$Prefix = 'https://asianembed.io'
$Cipher = Get-Content -Path $PSScriptRoot\cipher.json | ConvertFrom-Json

function Search-Drama {
    $Keyword = $(Write-Host 'Search Drama: ' -ForegroundColor DarkMagenta -NoNewLine; Read-Host)
    $Url = $Prefix + ('/search.html?keyword={0}' -f $Keyword)
    $req = Invoke-WebRequest -Uri $Url
    $Shows = [System.Collections.ArrayList]::new()
    $req.Links.href.ForEach{
        if ($_ -match '/videos/') {
            $Show = [PSCustomObject]@{
                Title = ($_ -split '/videos/(.*)')[1].Replace('-', ' ')
                Uri = $_
            }
            [void]$Shows.Add($Show)   
        }
    }
    return $Shows
}

function Get-Ep {
    param($PickedShow, $EpPrefix)
    $Url = $Prefix + $PickedShow
    $req = Invoke-WebRequest -Uri $Url
    $Eps = [System.Collections.ArrayList]::new()
    $req.Links.href.ForEach{
        if ($_ -match $EpPrefix) {
            $Ep = [PSCustomObject]@{
                Title = ($_ -split '/videos/(.*)')[1].Replace('-', ' ')
                Uri = $_
            }
            [void]$Eps.Add($Ep)
        }
    }
    return $Eps
}

function Select-Ep {
    param($EpList)
    $Title = $EpList.Title | fzf
    return $EpList.Where({$_.Title -eq $Title})
}

function Get-Id {
    param([Parameter(ValueFromPipeline = $true)]$Ep)
    $Url = $Prefix + $Ep
    $req = Invoke-WebRequest -Uri $Url
    $EmbedUrl = 'https:' + ($req.Content -split 'iframe src="(.+)(" allow.+)<\/iframe')[1]
    $Id = ($EmbedUrl -split 'id=(.+?)&')[1]
    return $Id
}

function Use-Encryption {
    param([Parameter(ValueFromPipeline = $true)]$Data)
    $AESCipher = New-Object System.Security.Cryptography.AesCryptoServiceProvider
    $AESCipher.Key = [byte[]]$Cipher.key.split(',')
    $AESCipher.IV = [byte[]]$Cipher.iv.split(',')

    $UnencryptedBytes     = [System.Text.Encoding]::UTF8.GetBytes($Data)
    $Encryptor            = $AESCipher.CreateEncryptor()
    $EncryptedBytes       = $Encryptor.TransformFinalBlock($UnencryptedBytes, 0, $UnencryptedBytes.Length)

    $EncryptedData         = [System.Convert]::ToBase64String($EncryptedBytes)
    $AESCipher.Dispose()
    return $EncryptedData
}

function Use-Decryption {
    param([Parameter(ValueFromPipeline = $true)]$Data)
    $AESCipher = New-Object System.Security.Cryptography.AesCryptoServiceProvider
    $AESCipher.Key = [byte[]]$Cipher.key.split(',')
    $AESCipher.IV = [byte[]]$Cipher.iv.split(',')

    $EncryptedBytes = [System.Convert]::FromBase64String($Data)
    $Decryptor = $AESCipher.CreateDecryptor();
    $UnencryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes, 0, $EncryptedBytes.Length)

    $DecryptedData = [System.Text.Encoding]::UTF8.GetString($UnencryptedBytes) | ConvertFrom-Json
    $AESCipher.Dispose()
    return $DecryptedData
}

function Get-Stream {
    param([Parameter(ValueFromPipeline = $true)]$EncryptedId)
    $AjaxUrl = $Prefix + '/encrypt-ajax.php?id=' + $EncryptedId
    $req = Invoke-WebRequest -Uri $AjaxUrl
    $Data = $req.Content | ConvertFrom-Json
    $Source = $Data.data | Use-Decryption
    return $Source.source[0].file
}
function Show-Text {
    param($Title)
    Write-Host ('Currently playing {0}' -f $Title) -ForegroundColor DarkMagenta
    # Write-Host '(n) next' -ForegroundColor DarkCyan
    # Write-Host '(r) replay' -ForegroundColor DarkGreen
    # Write-Host '(p) previous' -ForegroundColor DarkCyan
    Write-Host '(s) select' -ForegroundColor Blue
    Write-Host '(q) quit' -ForegroundColor Red
    return Read-Host -Prompt 'Choice'
}
function Open-Ep {
    param($Ep)
    $Title = $Ep.Title
    $StreamUrl = $Ep.Uri | Get-Id | Use-Encryption | Get-Stream
    mpv $StreamUrl --title=$Title --force-window=immediate &
}

$run = $true
$Shows = Search-Drama
$Title = $Shows.Title | fzf
$Show = $Shows.Where({$_.Title -eq $Title}).Uri
$EpPrefix = ($Show -split '(.+-)')[1]
$EpList = Get-Ep $Show $EpPrefix
while ($run -eq $true){
    $Ep = Select-Ep $EpList
    Open-Ep $Ep
    $Resp = Show-Text $Ep.Title
    if ($Resp -eq 'q'){$run = $false}
}


