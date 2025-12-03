:INST_03
echo.
echo  !Bg_Yellow!!Black![ DOWNLOAD ]!Reset! !Hi_Yellow!Mozilla Firefox...!Reset!
set "PS_SCRIPT=%TEMP%\dl_ff.ps1"
if exist "!PS_SCRIPT!" del "!PS_SCRIPT!"

:: --- PowerShell: Add User-Agent to bypass Mozilla block ---
echo $ErrorActionPreference = 'Stop' >> "!PS_SCRIPT!"
echo [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 >> "!PS_SCRIPT!"
echo try { >> "!PS_SCRIPT!"
echo     $url = "https://download.mozilla.org/?product=firefox-latest-ssl&os=win64&lang=en-US" >> "!PS_SCRIPT!"
echo     $dest = "$env:TEMP\firefox_setup.exe" >> "!PS_SCRIPT!"
echo     Write-Host "Downloading Firefox..." >> "!PS_SCRIPT!"
:: ใส่ UserAgent เพื่อหลอก Server ว่าเป็น Browser
echo     Invoke-WebRequest -Uri $url -OutFile $dest -UserAgent "Mozilla/5.0" >> "!PS_SCRIPT!"
echo } catch { >> "!PS_SCRIPT!"
echo     Write-Host "Error: $_" >> "!PS_SCRIPT!"
echo     exit 1 >> "!PS_SCRIPT!"
echo } >> "!PS_SCRIPT!"

powershell -ExecutionPolicy Bypass -File "!PS_SCRIPT!"

if exist "%TEMP%\firefox_setup.exe" (
    echo  !Bg_Green!!Hi_White![ INSTALL ]!Reset! !Hi_Green!Installing Firefox...!Reset!
    :: Firefox Silent Install
    "%TEMP%\firefox_setup.exe" /S
    
    del "%TEMP%\firefox_setup.exe" >nul 2>&1
    del "!PS_SCRIPT!" >nul 2>&1
    set "done_03=1" & set "failed_03=0"
) else (
    echo  !Bg_Red!!Hi_White![ ERROR ]!Reset! !Hi_Red!Download failed.!Reset!
    set "done_03=0" & set "failed_03=1"
)
set "sw_03=0"
exit /b
