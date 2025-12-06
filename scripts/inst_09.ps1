# =========================================================
#  FILE: inst_09.ps1 (LINE PC - Auto GUI Interaction)
#  Description: Uses SendKeys to simulate "Next > Agree > Install"
# =========================================================
$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

$url = "https://desktop.line-scdn.net/win/new/LineInst.exe"
$fileName = "LineInst.exe"
$dest = "$env:TEMP\$fileName"

# 1. โหลดไฟล์เอง (ไม่ผ่าน Master)
Write-Host "[ CLOUD ] Downloading LINE PC..." -ForegroundColor Cyan
Invoke-WebRequest -Uri $url -OutFile $dest -UseBasicParsing

if (Test-Path $dest) {
    Write-Host "[ LINE ] Launching Installer..." -ForegroundColor Yellow
    
    # สั่งรันโปรแกรมแบบไม่รอ (Start without wait)
    $proc = Start-Process -FilePath $dest -PassThru

    # เรียกใช้ WScript Shell เพื่อส่งปุ่มกด
    $wshell = New-Object -ComObject WScript.Shell
    
    # 2. รอและกดปุ่ม (Step-by-Step)
    Write-Host "[ AUTO ] Waiting for GUI..." -ForegroundColor Gray
    
    # รอ 3-5 วินาที ให้หน้าต่างแรกขึ้น (Language Selection)
    Start-Sleep -Seconds 5
    
    # ตรวจสอบว่าโปรแกรมยังรันอยู่ไหม
    if (-not $proc.HasExited) {
        # Activate หน้าต่าง (เพื่อให้แน่ใจว่าปุ่มกดไม่วืด)
        # ลอง Activate โดยใช้ชื่อ Title ทั่วไปของ Line Installer
        $wshell.AppActivate("LINE Installation") 
        $wshell.AppActivate("LINE Installer")
        
        # --- KEY SEQUENCE ---
        # 1. หน้าเลือกภาษา (English) -> กด Enter (OK)
        $wshell.SendKeys("{ENTER}") 
        Start-Sleep -Milliseconds 1500

        # 2. หน้า Welcome -> กด Alt+N (Next)
        $wshell.SendKeys("%(N)") 
        Start-Sleep -Milliseconds 1000

        # 3. หน้า License (ตัวปัญหา!) -> กด Alt+A (I Agree)
        $wshell.SendKeys("%(A)")
        Start-Sleep -Milliseconds 1000

        # 4. หน้า Install Location -> กด Alt+I (Install)
        $wshell.SendKeys("%(I)")
        
        Write-Host "[ AUTO ] Installation started..." -ForegroundColor Green

        # 5. รอจนกว่า Process จะจบ (ติดตั้งเสร็จ)
        $proc.WaitForExit()
        
        # 6. กดปิดหน้าต่าง Finish (ถ้ามี)
        # บางที Line ติดตั้งเสร็จมันจะเปิดตัวเองขึ้นมา เราอาจต้อง Kill Process
        Start-Sleep -Seconds 2
        Get-Process "LineInst" -ErrorAction SilentlyContinue | Stop-Process -Force
        Get-Process "LINE" -ErrorAction SilentlyContinue | Stop-Process -Force # ปิดตัวโปรแกรม LINE ที่เด้งขึ้นมา

        Write-Host "[ SUCCESS ] LINE PC Installed." -ForegroundColor Green
        
        # Cleanup
        Remove-Item $dest -Force -ErrorAction SilentlyContinue
    } else {
        throw "Installer closed unexpectedly."
    }
} else {
    throw "Download Failed"
}
