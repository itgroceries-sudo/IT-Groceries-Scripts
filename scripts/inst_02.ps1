# เปลี่ยนมาใช้ MSI เพื่อแก้ปัญหาติดตั้งไม่สมบูรณ์
$url = "https://dl.google.com/chrome/install/googlechromestandaloneenterprise64.msi"
$fileName = "ChromeSetup.msi"

# Master Engine จะรู้เองว่าเป็น MSI แล้วใช้ msiexec /i ให้
# เราใส่แค่คำสั่ง Silent ก็พอ
$installArgs = "/qn /norestart"

. "$env:TEMP\Master.ps1"
