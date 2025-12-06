# AnyDesk (Fixed Arguments)
$url = "https://download.anydesk.com/AnyDesk.msi"
$fileName = "AnyDesk.msi"

# [FIX] ไม่ระบุ path ปลายทาง (ให้มันลง Default เอง) เพื่อป้องกันปัญหาเรื่อง Quote ใน PowerShell
# ใช้คำสั่ง --install --start-with-win --silent ตามมาตรฐาน
$installArgs = "/qn"

. "$env:TEMP\Master.ps1"
