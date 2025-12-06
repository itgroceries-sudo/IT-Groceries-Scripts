# --- IT Groceries Shop Launcher ---
# Version: 1.3 (Force Clean)
# See 'Changes.log' for version history.

$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Host.UI.RawUI.WindowTitle = "IT Groceries Launcher"

# 1. Config & Window
$u='[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h,IntPtr i,int x,int y,int cx,int cy,uint f);[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();'
$t=Add-Type -MemberDefinition $u -Name 'Win32' -Namespace Win32 -PassThru
$h=$t::GetConsoleWindow(); $t::SetWindowPos($h,0,200,200,600,300,0x41) >$null

# 2. Security Check
if ((Read-Host "Enter Password") -ne "ITG2") { Write-Host "Access Denied"; sleep 2; exit }

# 3. Cloud Configuration
$BaseURL = "https://raw.githubusercontent.com/itgroceries-sudo/IT-Groceries-Scripts/main"
$tmpDir  = "$env:TEMP"

# [STEALTH] Random Filename
$RandomName = -join ((65..90) + (97..122) + (48..57) | Get-Random -Count 8 | % {[char]$_})
$StealthFile = "$tmpDir\$RandomName.cmd"
$MasterFile = "$tmpDir\Master.ps1"

Write-Host "`n[ INITIALIZING ] Secure Boot..." -ForegroundColor Cyan

try {
    # =========================================================
    # [FIX] FORCE CLEANUP ROUTINE
    # แก้ปัญหา Access Denied กรณีไฟล์เก่าค้างและเป็น Hidden
    # =========================================================
    if (Test-Path $MasterFile) {
        # ปลด Hidden/ReadOnly ออกก่อน
        (Get-Item $MasterFile).Attributes = 'Normal'
        # ลบทิ้งแบบบังคับ
        Remove-Item $MasterFile -Force -ErrorAction SilentlyContinue
    }
    # =========================================================

    # Step 1: Download Master
    Invoke-WebRequest -Uri "$BaseURL/Master.ps1" -OutFile $MasterFile -UseBasicParsing -ErrorAction Stop
    (Get-Item $MasterFile).Attributes = 'Hidden'

    # Step 2: Download UI
    $cmdContent = (Invoke-WebRequest -Uri "$BaseURL/InstallerCloud.cmd" -UseBasicParsing -ErrorAction Stop).Content
    $cmdContent = $cmdContent -replace "`r`n", "`n" -replace "`n", "`r`n"
    [System.IO.File]::WriteAllText($StealthFile, $cmdContent, [System.Text.Encoding]::ASCII)

    # Step 3: Execute
    if (Test-Path $StealthFile) {
        (Get-Item $StealthFile).Attributes = 'Hidden'
        Write-Host "Launching..." -ForegroundColor Green
        Start-Sleep 1
        Start-Process -FilePath $StealthFile -ArgumentList "am_admin" -Verb RunAs -Wait
        
        # Final Cleanup
        if (Test-Path $StealthFile) { (Get-Item $StealthFile).Attributes = 'Normal'; Remove-Item $StealthFile -Force }
        if (Test-Path $MasterFile)  { (Get-Item $MasterFile).Attributes  = 'Normal'; Remove-Item $MasterFile  -Force }
    }
} catch {
    Write-Host "Error: $_" -ForegroundColor Red
    Start-Sleep 3
}
