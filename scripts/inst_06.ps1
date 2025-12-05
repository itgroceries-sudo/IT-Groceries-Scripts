$url = "https://download.anydesk.com/AnyDesk.exe"
$fileName = "AnyDesk.exe"
# AnyDesk ต้องการ path ปลายทางชัดเจนสำหรับการติดตั้งแบบเงียบ
$installArgs = "--install `"$env:ProgramFiles(x86)\AnyDesk`" --start-with-win --silent"

. "$env:TEMP\Master.ps1"
