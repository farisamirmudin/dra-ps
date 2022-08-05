$ProgressPreference = 'Continue'
$Prefix = 'https://asianembed.io'

$Url = $Prefix + '/search.html?keyword=alchemy'
$req = Invoke-WebRequest -Uri $Url
$Links = $req.Links.href
$Shows = [System.Collections.ArrayList]::new()
$Links.ForEach{
    if ($_ -match '/videos/') {
        [void]$Shows.Add($_)
        Write-Host -Object ($_ -split '\/videos\/(.+)')[1].Replace('-',' ')
    }
} 
[Int32]$PickShow = Read-Host -Prompt 'Pick Show '
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
$Url
$req = Invoke-WebRequest -Uri $Url
$EmbedUrl = 'https:' + ($req.Content -split 'iframe src="(.+)(" allow.+)<\/iframe')[1]
$EmbedUrl
$Parsed = [System.Uri]$EmbedUrl
$Id = ($Parsed.Query -split 'id=(.+)&x')[1]

$key='3933343232313932343333393532343839373532333432393038353835373532'
$iv='39323632383539323332343335383235'


$AjaxPrefix = $Prefix + '/encrypt-ajax.php?'
$AjaxUrl = $AjaxPrefix + 'id=' + ($Id | openssl enc -e -aes-256-cbc -K $key -iv $iv -a)
$AjaxUrl
$req = Invoke-WebRequest -Uri $AjaxUrl -UserAgent 'Mozilla/5.0 (X11; Linux x86_64; rv:99.0) Gecko/20100101 Firefox/100.0'
$req.Content
$Data = $req.Content | ConvertFrom-Json

$Source = $Data.data | openssl enc -a -d -aes-256-cbc -K $key -iv $iv | ConvertFrom-Json
$StreamUrl = $Source.source[0].file
$StreamUrl

mpv $StreamUrl --title=vid --force-window=immediate > nul