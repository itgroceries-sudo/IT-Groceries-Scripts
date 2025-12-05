# --- IT Groceries Shop Launcher ---
$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$Host.UI.RawUI.WindowTitle = "IT Groceries Launcher"

# 1. Config & Window Setup
$u='[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h,IntPtr i,int x,int y,int cx,int cy,uint f);[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();'
$t=Add-Type -MemberDefinition $u -Name 'Win32' -Namespace Win32 -PassThru
$h=$t::GetConsoleWindow(); $t::SetWindowPos($h,0,200,200,600,300,0x41) >$null

# 2. Security Check
$myPassword = "ITG2"
Write-Host "`n[ SECURITY CHECK ]" -ForegroundColor Yellow
if ((Read-Host "Enter Password") -ne $myPassword) { Write-Host "Access Denied"; sleep 2; exit }

# ==============================================================================
# [CONFIG] URL หน้าบ้าน (Root) ตามผล Debug สีเขียว
# ==============================================================================
$BaseURL = "https://raw.githubusercontent.com/itgroceries-sudo/IT-Groceries-Scripts/main"
$tmpDir  = "$env:TEMP"
# ==============================================================================

Write-Host "`n[ INITIALIZING ] Connecting to Cloud Repository..." -ForegroundColor Cyan

try {
    # Step 1: โหลด Master Engine (จาก Root)
    Invoke-WebRequest -Uri "$BaseURL/Master.ps1" -OutFile "$tmpDir\Master.ps1" -UseBasicParsing -ErrorAction Stop

    # Step 2: โหลด Installer UI (จาก Root)
    $cmdContent = (Invoke-WebRequest -Uri "$BaseURL/InstallerCloud.cmd" -UseBasicParsing -ErrorAction Stop).Content
    
    # แก้ CRLF
    $cmdContent = $cmdContent -replace "`r`n", "`n" -replace "`n", "`r`n"
    [System.IO.File]::WriteAllText("$tmpDir\Setup.cmd", $cmdContent, [System.Text.Encoding]::ASCII)

    # Step 3: รันโปรแกรม
    if (Test-Path "$tmpDir\Setup.cmd") {
        Write-Host "Launching Installer..." -ForegroundColor Green
        Start-Sleep 1
        Start-Process -FilePath "$tmpDir\Setup.cmd" -ArgumentList "am_admin" -Verb RunAs -Wait
        
        # Cleanup
        Remove-Item "$tmpDir\Setup.cmd" -Force
        Remove-Item "$tmpDir\Master.ps1" -Force
    }
} catch {
    Write-Host "Download Failed: $_" -ForegroundColor Red
    Write-Host "Check URL: $BaseURL" -ForegroundColor Gray
    Start-Sleep 5
}
