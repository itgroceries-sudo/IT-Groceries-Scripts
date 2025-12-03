$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Checking Notepad++ Github..." -ForegroundColor Cyan
    $api = "https://api.github.com/repos/notepad-plus-plus/notepad-plus-plus/releases/latest"
    $json = Invoke-RestMethod -Uri $api
    $asset = $json.assets | Where-Object {$_.name -like "*Installer.x64.exe"} | Select-Object -First 1
    
    if ($asset) {
        $dest = "$env:TEMP\npp_setup.exe"
        Write-Host "Downloading $($asset.name)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $dest
        
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/S" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Asset not found." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
