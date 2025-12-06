$url = "https://download.anydesk.com/AnyDesk.exe"
$fileName = "AnyDesk.exe"

# [FIXED]
# 1. ต้องระบุ Path ปลายทางเสมอ (ตามภาพ UAC ที่คุณส่งมา)
# 2. ใช้ ` (backtick) หน้า " เพื่อ escape เครื่องหมายคำพูดใน PowerShell
$installArgs = "--install `"${env:ProgramFiles(x86)}\AnyDesk`" --create-desktop-icon --silent --create-shortcuts"

. "$env:TEMP\Master.ps1"
