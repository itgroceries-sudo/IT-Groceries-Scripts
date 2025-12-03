:INST_07
echo.
echo  !Bg_Yellow!!Black![ DOWNLOAD ]!Reset! !Hi_Yellow!Zoom Meeting...!Reset!
set "RND=%RANDOM%" & set "TMP_DIR=%TEMP%\ITG_!RND!" & md "!TMP_DIR!"
set "SETUP_FILE=!TMP_DIR!\zoom.exe"

powershell -Command "Invoke-WebRequest 'https://zoom.us/client/latest/ZoomInstaller.exe' -OutFile '!SETUP_FILE!'"

if exist "!SETUP_FILE!" (
    echo  !Bg_Green!!Hi_White![ INSTALL ]!Reset! !Hi_Green!Installing...!Reset!
    "!SETUP_FILE!" /silent /install
    set "done_07=1" & set "failed_07=0"
) else (
    echo  !Bg_Red!!Hi_White![ ERROR ]!Reset! !Hi_Red!Download failed.!Reset!
    set "done_07=0" & set "failed_07=1"
)
rd /s /q "!TMP_DIR!" >nul 2>&1
set "sw_07=0"
exit /b
