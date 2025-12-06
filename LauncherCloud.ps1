# --- IT Groceries Shop Launcher ---
# Version: 1.2 (Stealth)
# See 'Changes.log' for version history.

$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Host.UI.RawUI.WindowTitle = "IT Groceries Launcher"

# 1. Config & Window
$u='[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h,IntPtr i,int x,int y,int cx,int cy,uint f);[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();'
$t=Add-Type -MemberDefinition $u -Name 'Win32' -Namespace Win32 -PassThru
$h=$t::GetConsoleWindow(); $t::SetWindowPos($h,0,200,200,600,300,0x41) >$null

# 2. Security Check
Write-Host "`n[ SECURITY CHECK ]" -ForegroundColor Yellow
if ((Read-Host "Enter Password") -ne "ITG2") { Write-Host "Access Denied"; sleep 2; exit }

# 3. Cloud Configuration
$BaseURL = "https://raw.githubusercontent.com/itgroceries-sudo/IT-Groceries-Scripts/main"
$tmpDir  = "$env:TEMP"

# [STEALTH] สร้างชื่อไฟล์แบบสุ่ม (เช่น x8k29a.cmd) เพื่อไม่ให้ User จำชื่อไฟล์ได้
$RandomName = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 8 | % {[char]$_})
$StealthFile = "$tmpDir\$RandomName.cmd"

Write-Host "`n[ INITIALIZING ] SECURITY LAUNCHING..." -ForegroundColor Cyan

try {
    # Step 1: Master Engine
    Invoke-WebRequest -Uri "$BaseURL/Master.ps1" -OutFile "$tmpDir\Master.ps1" -UseBasicParsing -ErrorAction Stop
    # ซ่อนไฟล์ Master ด้วย
    (Get-Item "$tmpDir\Master.ps1").Attributes = 'Hidden'

    # Step 2: Installer UI
    $cmdContent = (Invoke-WebRequest -Uri "$BaseURL/InstallerCloud.cmd" -UseBasicParsing -ErrorAction Stop).Content
    $cmdContent = $cmdContent -replace "`r`n", "`n" -replace "`n", "`r`n"
    
    # เขียนไฟล์ลงชื่อสุ่ม
    [System.IO.File]::WriteAllText($StealthFile, $cmdContent, [System.Text.Encoding]::ASCII)

    # [STEALTH] สั่งซ่อนไฟล์ทันที (Hidden Attribute)
    if (Test-Path $StealthFile) {
        (Get-Item $StealthFile).Attributes = 'Hidden'
        
        Write-Host "Launching..." -ForegroundColor Green
        Start-Sleep 1
        
        # รันไฟล์ที่ซ่อนอยู่
        Start-Process -FilePath $StealthFile -ArgumentList "am_admin" -Verb RunAs -Wait
        
        # ทำลายหลักฐาน (Cleanup)
        Remove-Item $StealthFile -Force
        Remove-Item "$tmpDir\Master.ps1" -Force
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Start-Sleep 3
}

