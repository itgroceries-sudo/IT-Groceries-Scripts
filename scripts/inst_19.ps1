$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Checking PowerToys Github..." -ForegroundColor Cyan
    $api = "https://api.github.com/repos/microsoft/PowerToys/releases/latest"
    $json = Invoke-RestMethod -Uri $api
    $asset = $json.assets | Where-Object {$_.name -like "*-x64.exe"} | Select-Object -First 1
    
    if ($asset) {
        $dest = "$env:TEMP\ptoys_setup.exe"
        Write-Host "Downloading $($asset.name)..." -ForegroundColor Yellow
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $dest
        
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        Start-Process -FilePath $dest -ArgumentList "/install /quiet /norestart" -Wait
        Remove-Item $dest -Force
        exit 0
    } else { throw "Asset not found." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
