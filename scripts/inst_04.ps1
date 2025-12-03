$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Finding latest VLC..." -ForegroundColor Cyan
    $base = "http://download.videolan.org/pub/videolan/vlc/last/win64/"
    $web = Invoke-WebRequest -Uri $base -UseBasicParsing
    $file = $web.Links.href | Where-Object {$_ -like "*.exe"} | Select-Object -First 1
    
    if ($file) {
        $url = $base + $file
        $dest = "$env:TEMP\vlc_setup.exe"
        
        Write-Host "Downloading from $url" -ForegroundColor Yellow
        Invoke-WebRequest -Uri $url -OutFile $dest
        
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/S" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "VLC link not found." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
