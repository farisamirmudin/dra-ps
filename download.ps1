$Prefix = 'https://cache.387e6278d8e06083d813358762e0ac63.com/'

$ProgressPreference = 'Continue'
$Url = 'https://cache.387e6278d8e06083d813358762e0ac63.com/37ebabec-1085-11ed-912a-a0369ffdb8c8.m3u8?videoid=222835251249'
Invoke-WebRequest -Uri $Url -OutFile playlist.m3u8

$Playlist = Get-Content -Path $PSScriptRoot\playlist.m3u8

$Playlist | % {
    if ($PSItem -notmatch '^#') {
        $SegmentUri = $PSItem
        $SegmentFileName = ($SegmentUri -split '-([\d]+\.ts)')[1]
        # Invoke-WebRequest -Uri $SegmentUri -OutFile $PSScriptRoot\temp\$SegmentFileName
        Add-Content -Path $PSScriptRoot\temp\tsfile.txt -Value ('file ''{0}''' -f $SegmentFileName)
    }
}
ffmpeg -f concat -i .\temp\tsfile.txt -c copy ep1.mp4