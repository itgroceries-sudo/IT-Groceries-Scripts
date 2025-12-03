$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

try {
    Write-Host "[ CLOUD ] Downloading LINE PC (MSI Enterprise)..." -ForegroundColor Cyan
    
    # 1. ใช้ลิงก์ MSI สำหรับองค์กร (ติดตั้งเงียบแน่นอน 100%)
    $url = "https://desktop.line-scdn.net/win/msi/LineInst.msi"
    $dest = "$env:TEMP\LineInst.msi"
    
    if (Test-Path $dest) { Remove-Item $dest -Force }
    
    Invoke-WebRequest -Uri $url -OutFile $dest
    
    if (Test-Path $dest) {
        Write-Host "[ CLOUD ] Installing..." -ForegroundColor Green
        
        # 2. สั่งติดตั้งผ่าน msiexec แบบเงียบ (/qn)
        $args = "/i `"$dest`" /qn /norestart"
        $proc = Start-Process -FilePath "msiexec.exe" -ArgumentList $args -Wait -PassThru
        
        if ($proc.ExitCode -eq 0) {
            # 3. สั่งปิด LINE ที่อาจจะเด้งขึ้นมาเองหลังลงเสร็จ
            Start-Sleep -Seconds 5
            Stop-Process -Name "Line" -Force -ErrorAction SilentlyContinue
            Stop-Process -Name "LineInst" -Force -ErrorAction SilentlyContinue
            
            Remove-Item $dest -Force
            exit 0
        } else {
            throw "Installation failed (Exit Code: $($proc.ExitCode))"
        }
    } else { throw "Download failed." }
} catch {
    Write-Host "[ ERROR ] $_" -ForegroundColor Red
    exit 1
}
