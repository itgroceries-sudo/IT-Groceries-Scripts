:INST_09
echo.
echo  !Bg_Yellow!!Black![ DOWNLOAD ]!Reset! !Hi_Yellow!LINE PC (Silent Force)...!Reset!
set "RND=%RANDOM%" & set "TMP_DIR=%TEMP%\ITG_!RND!" & md "!TMP_DIR!"
set "SETUP_FILE=!TMP_DIR!\line.exe"

:: 1. ดาวน์โหลด
powershell -Command "Invoke-WebRequest 'https://desktop.line-scdn.net/win/new/LineInst.exe' -OutFile '!SETUP_FILE!'"

if exist "!SETUP_FILE!" (
    echo  !Bg_Green!!Hi_White![ INSTALL ]!Reset! !Hi_Green!Installing...!Reset!
    
    :: 2. สั่งติดตั้งแบบ Silent (NSIS)
    :: ใช้ /S (ตัวใหญ่) และกำหนด Path ปลายทางชัดเจนเพื่อกันเหนียว
    "!SETUP_FILE!" /S
    
    :: 3. รอสักพัก แล้วสั่งปิด LINE ที่อาจจะเด้งขึ้นมาเอง
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
