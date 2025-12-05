# --- IT Groceries Shop Launcher (Unified) ---
$ErrorActionPreference = 'SilentlyContinue'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# 1. Config & Window
$Host.UI.RawUI.WindowTitle = "IT Groceries Launcher"
$u='[DllImport("user32.dll")] public static extern bool SetWindowPos(IntPtr h,IntPtr i,int x,int y,int cx,int cy,uint f);[DllImport("kernel32.dll")] public static extern IntPtr GetConsoleWindow();'
$t=Add-Type -MemberDefinition $u -Name 'Win32' -Namespace Win32 -PassThru
$h=$t::GetConsoleWindow(); $t::SetWindowPos($h,0,200,200,600,300,0x41) >$null

# 2. Security Check
if ((Read-Host "Enter Password") -ne "ITG2") { Write-Host "Access Denied"; sleep 2; exit }

# ==============================================================================
# [CONFIG] ศูนย์รวมความเจริญ (แก้บรรทัดนี้ที่เดียว จบ!)
# ==============================================================================
# ... (ส่วนหัวเหมือนเดิม) ...

# 1. Config Base URL (หน้าบ้าน)
# [แก้แล้ว] ลิงก์สั้นลง (ชี้ไปที่ Root ของ Main)
$BaseURL = "https://raw.githubusercontent.com/itgroceries-sudo/IT-Groceries-Scripts/main"
$tmpDir  = "$env:TEMP"

Write-Host "`n[ INITIALIZING ] Connecting to Cloud Repository..." -ForegroundColor Cyan

try {
    # Step 1: โหลด Master Engine (อยู่ที่หน้าแรก ใช้ BaseURL ได้เลย)
    Invoke-WebRequest -Uri "$BaseURL/Master.ps1" -OutFile "$tmpDir\Master.ps1" -UseBasicParsing -ErrorAction Stop

    # Step 2: โหลด Installer UI (อยู่ที่หน้าแรก ใช้ BaseURL ได้เลย)
    $cmdContent = (Invoke-WebRequest -Uri "$BaseURL/InstallerCloud.cmd" -UseBasicParsing -ErrorAction Stop).Content
    
    # ... (ส่วนรันโปรแกรมเหมือนเดิม) ...

    # Step 3: รันโปรแกรม
    if (Test-Path "$tmpDir\Setup.cmd") {
        Write-Host "Launching Installer..." -ForegroundColor Green
        Start-Sleep 1
        Start-Process -FilePath "$tmpDir\Setup.cmd" -ArgumentList "am_admin" -Verb RunAs -Wait
        
        # Cleanup (เก็บกวาด)
        Remove-Item "$tmpDir\Setup.cmd" -Force
        Remove-Item "$tmpDir\Master.ps1" -Force
    }
} catch {
    Write-Host "Download Failed: $_" -ForegroundColor Red
    Write-Host "Check URL: $BaseURL" -ForegroundColor Gray
    Start-Sleep 5
}