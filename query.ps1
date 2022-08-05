$ProgressPreference = 'Continue'
$Prefix = 'https://asianembed.io'

$Keyword = Read-Host -Prompt 'Search Drama'
$Url = $Prefix + ('/search.html?keyword={0}' -f $Keyword)
$req = Invoke-WebRequest -Uri $Url
$Links = $req.Links.href
$Shows = [System.Collections.ArrayList]::new()
$i = 0
$Links.ForEach{
    if ($_ -match '/videos/') {
        [void]$Shows.Add($_)
        Write-Host -Object (('({0}) ' -f ($i+1)) + ($_ -split '\/videos\/(.+)')[1].Replace('-',' '))
        $i++
    }
} 
[Int32]$PickShow = Read-Host -Prompt 'Pick Show'
$EpPrefix = ($Shows[$PickShow-1] -split '(.+-)')[1]
$Url = $Prefix + $Shows[$PickShow-1]
$req = Invoke-WebRequest -Uri $Url
$Links = $req.Links.href
$Eps = [System.Collections.ArrayList]::new()
$Links.ForEach{
    if ($_ -match $EpPrefix) {
        $Current = [PSCustomObject]@{
            EpNum = ($_ -split '([\d]+-?[\d]*)$')[1]
            EpUrl = $_
        }
        [void]$Eps.Add($Current)
    }
}
if ($Eps[0].EpNum -lt $Eps[-1].EpNum){
    $Upper = $Eps[-1].EpNum
    $Lower = $Eps[0].EpNum
} else {
    $Upper = $Eps[0].EpNum
    $Lower = $Eps[-1].EpNum
}
[string]$PickEp = (Read-Host -Prompt ('Pick Episode ({0}-{1})' -f $Lower, $Upper)).Replace('.', '-')

$Url = $Prefix + $Eps.Where({$_.EpNum -eq $PickEp}).EpUrl
$req = Invoke-WebRequest -Uri $Url
$EmbedUrl = 'https:' + ($req.Content -split 'iframe src="(.+)(" allow.+)<\/iframe')[1]
$Id = ($EmbedUrl -split 'id=(.+?)&')[1]

$Cipher = Get-Content -Path $PSScriptRoot\cipher.json | ConvertFrom-Json
[byte[]]$Key = $Cipher.key.split(',')
[byte[]]$Iv = $Cipher.iv.split(',')
$AjaxPrefix = $Prefix + '/encrypt-ajax.php?'

$AESCipher = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$AESCipher.Key = $Key
$AESCipher.IV = $Iv

$UnencryptedBytes     = [System.Text.Encoding]::UTF8.GetBytes($Id)
$Encryptor            = $AESCipher.CreateEncryptor()
$EncryptedBytes       = $Encryptor.TransformFinalBlock($UnencryptedBytes, 0, $UnencryptedBytes.Length)

$CrytpedId          = [System.Convert]::ToBase64String($EncryptedBytes)
$AESCipher.Dispose()

$AjaxUrl = $AjaxPrefix + 'id=' + $CrytpedId
$req = Invoke-WebRequest -Uri $AjaxUrl
$Data = $req.Content | ConvertFrom-Json

$AESCipher = New-Object System.Security.Cryptography.AesCryptoServiceProvider
$AESCipher.Key = $Key

$EncryptedBytes = [System.Convert]::FromBase64String($Data.data)
$AESCipher.IV = $Iv
$Decryptor = $AESCipher.CreateDecryptor();
$UnencryptedBytes = $Decryptor.TransformFinalBlock($EncryptedBytes, 0, $EncryptedBytes.Length)

$Source = [System.Text.Encoding]::UTF8.GetString($UnencryptedBytes) | ConvertFrom-Json
$AESCipher.Dispose()

$StreamUrl = $Source.source[0].file

mpv\mpv.exe $StreamUrl --title=vid --force-window=immediate


