:INST_09
echo.
echo  !Bg_Yellow!!Black![ DOWNLOAD ]!Reset! !Hi_Yellow!LINE PC (Silent Force)...!Reset!
set "RND=%RANDOM%" & set "TMP_DIR=%TEMP%\ITG_!RND!" & md "!TMP_DIR!"
set "PS_SCRIPT=!TMP_DIR!\dl_line.ps1" & set "SETUP_FILE=!TMP_DIR!\line.exe"

:: --- PowerShell: Bulletproof Download (TLS 1.2 + UserAgent) ---
echo $ErrorActionPreference = 'Stop' >> "!PS_SCRIPT!"
echo [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 >> "!PS_SCRIPT!"
echo try { >> "!PS_SCRIPT!"
echo     $url = "https://desktop.line-scdn.net/win/new/LineInst.exe" >> "!PS_SCRIPT!"
echo     Write-Host "Downloading LINE PC..." >> "!PS_SCRIPT!"
echo     Invoke-WebRequest -Uri $url -OutFile "!SETUP_FILE!" -UserAgent "Mozilla/5.0" >> "!PS_SCRIPT!"
echo } catch { >> "!PS_SCRIPT!"
echo     Write-Host "Error: $_" >> "!PS_SCRIPT!"
echo     exit 1 >> "!PS_SCRIPT!"
echo } >> "!PS_SCRIPT!"

powershell -ExecutionPolicy Bypass -File "!PS_SCRIPT!"

if exist "!SETUP_FILE!" (
    echo  !Bg_Green!!Hi_White![ INSTALL ]!Reset! !Hi_Green!Installing...!Reset!
    
    :: LINE ใช้ NSIS Installer: /S ต้องตัวใหญ่เสมอ
    "!SETUP_FILE!" /S
    
    :: รอและสั่งปิด Process ที่อาจเด้งขึ้นมา
    timeout /t 5 >nul
    taskkill /f /im Line.exe >nul 2>&1
    taskkill /f /im LineInst.exe >nul 2>&1
    
    set "done_09=1" & set "failed_09=0"
) else (
    echo  !Bg_Red!!Hi_White![ ERROR ]!Reset! !Hi_Red!Download failed.!Reset!
    set "done_09=0" & set "failed_09=1"
)
rd /s /q "!TMP_DIR!" >nul 2>&1
set "sw_09=0"
exit /b
