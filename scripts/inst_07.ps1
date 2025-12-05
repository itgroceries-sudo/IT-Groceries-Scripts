# ==============================================================================================
#  FILE: inst_07.ps1 (Zoom Meeting - MSI)
# ==============================================================================================
$url = "https://zoom.us/client/latest/ZoomInstallerFull.msi"
$fileName = "ZoomInstaller.msi"
$installArgs = "/qn"
. "$env:TEMP\Master.ps1"
