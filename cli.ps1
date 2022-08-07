$ProgressPreference = 'Continue'
$Prefix = 'https://asianembed.io'
$Cipher = Get-Content -Path $PSScriptRoot\cipher.json | ConvertFrom-Json

function Get-Links {
    param($Links, $Pattern)
    $Datas = [System.Collections.ArrayList]::new()
    $Links.ForEach{
        if ($_ -match $Pattern) {
            $Groups = $_ -split '\/videos\/(.+episode-[\d]+)(-[\d])*$'
            $Title = $Groups[1].Replace('-',' ')
            if ($Groups[2]) {
                $Title = $Title + $Groups[2].Replace('-','.')
            }
            $Data = [PSCustomObject]@{
                Title = $Title
                Uri = $_
            }
            [void]$Datas.Add($Data)
        }
    }
    return $Datas
}
function Search-Drama {
    $Keyword = $(Write-Host 'Search Drama: ' -ForegroundColor DarkMagenta -NoNewLine; Read-Host)
    $Url = $Prefix + ('/search.html?keyword={0}' -f $Keyword)
    $req = Invoke-WebRequest -Uri $Url
    $Pattern = '/videos/'
    $Shows = Get-Links $req.Links.href $Pattern
    return $Shows
}

function Get-Ep {
    param($PickedShow, $EpPrefix)
    $Url = $Prefix + $PickedShow
    $req = Invoke-WebRequest -Uri $Url
    $Eps = Get-Links $req.Links.href $EpPrefix
    return $Eps
}

function Select-Ep {
    param($EpList)
    $Title = $EpList.Title | Sort-Object {[float]($_ -split '([\d]+[-.]?[\d]*$)')[1]} | Get-Unique | fzf
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
    Write-Host '(s) select episode' -ForegroundColor Blue
    Write-Host '(w) watch another drama' -ForegroundColor Green
    Write-Host '(q) quit' -ForegroundColor Red
    return Read-Host -Prompt 'Choice'
}
function Open-Ep {
    param($Ep)
    $Title = $Ep.Title
    $StreamUrl = $Ep.Uri | Get-Id | Use-Encryption | Get-Stream
    mpv $StreamUrl --title=$Title --force-window=immediate &
}

$run1 = $true
while ($run1 -eq $true) {
    Clear-Host
    $run2 = $true
    $Shows = Search-Drama
    $Title = $Shows.Title | fzf
    $Show = $Shows.Where({$_.Title -eq $Title}).Uri
    $EpPrefix = ($Show -split '(.+-)')[1]
    $EpList = Get-Ep $Show $EpPrefix
    while ($run2 -eq $true){
        $Ep = Select-Ep $EpList
        Open-Ep $Ep
        Clear-Host
        $Resp = Show-Text $Ep.Title
        if ($Resp -eq 'q'){$run1 = $run2 = $false} 
        if ($Resp -eq 'w'){$run2 = $false}
}
}


