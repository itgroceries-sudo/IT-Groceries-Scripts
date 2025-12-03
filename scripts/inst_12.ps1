$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Checking OBS Version..." -ForegroundColor Cyan
    $resp = Invoke-WebRequest -Uri "https://github.com/obsproject/obs-studio/releases/latest" -MaximumRedirection 0 -ErrorAction SilentlyContinue
    $ver = $resp.Headers.Location.Split('/')[-1]
    
    if ($ver) {
        Write-Host "Version detected: $ver" -ForegroundColor Yellow
        $url = "https://github.com/obsproject/obs-studio/releases/download/$ver/OBS-Studio-$ver-Full-Installer-x64.exe"
        $dest = "$env:TEMP\obs_setup.exe"
        
        Write-Host "Downloading..."
        Invoke-WebRequest -Uri $url -OutFile $dest
        
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/S" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Could not detect version." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
