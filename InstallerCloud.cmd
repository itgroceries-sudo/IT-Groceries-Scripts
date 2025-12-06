@echo off
setlocal EnableDelayedExpansion

:: ========================================================= 
:: 00. START :: CHANGE LOG
:: =========================================================
:: v10.3 (Lock Restoration)
::   - [System] Restored advanced Window Locking (No Resize/Close).
::   - [System] Updated centering logic to support 100 columns.
::
:: v10.2 (Wide Screen)
::   - [UI] Increased window width to 100 columns.
::
:: v10.1 (Layout Polish)
::   - [UI] Moved !arch_xx! tag to the end of line.
:: ========================================================= 
:: 00. END :: CHANGE LOG
:: =========================================================


:: =========================================================
::  1. INIT & CONFIG
:: =========================================================
set "Ver=10.3 (Full Lock)"
:: [Root Base]
set "CLOUD_BASE=https://raw.githubusercontent.com/itgroceries-sudo/IT-Groceries-Scripts/main"

set "MASTER_SCRIPT=%TEMP%\Master.ps1"
set "ARIA2_EXE=%TEMP%\aria2c.exe"

title IT Groceries Shop (Cloud UI)
:: [Wide Screen 100 Cols]
mode con: cols=100 lines=26
cd /d "%~dp0"

:: Check Admin
if not "%1"=="am_admin" (
    powershell -Command "Start-Process -Verb RunAs -FilePath '%~f0' -ArgumentList 'am_admin'"
    exit /b
)

:: Check Master
if not exist "%MASTER_SCRIPT%" (
    powershell -Command "Invoke-WebRequest -Uri '%CLOUD_BASE%/Master.ps1' -OutFile '%MASTER_SCRIPT%'"
)

:: =========================================================
::  2. UI SETUP & TOOLS
:: =========================================================
call :SETUP_COLORS_AND_PATHS
call :FIX_WINDOW

:MAIN_MENU
cls
call :UPDATE_STATUS
echo.
echo  !Bold!!Cyan!==============================================================================================!Reset!
echo                         !Bold!!Bg_Green!!Hi_White!IT GROCERIES SHOP - CLOUD INSTALLER!Reset! !Bg_Magenta!!Hi_Yellow!(v%Ver% ^| %date%)!Reset!
echo  !Bold!!Cyan!==============================================================================================!Reset!
echo.
:: Layout: Name + Padding + [Status] + Arch (Fixed Alignment)
echo    !Bold!!Hi_Cyan![01]!Reset! !clr_01! 7-Zip                 [!st_01!]!Reset! !arch_01!     !Bold!!Hi_Cyan![11]!Reset! !clr_11! TeamViewer           [!st_11!]!Reset! !arch_11!
echo    !Bold!!Hi_Cyan![02]!Reset! !clr_02! Google Chrome         [!st_02!]!Reset! !arch_02!     !Bold!!Hi_Cyan![12]!Reset! !clr_12! OBS Studio           [!st_12!]!Reset! !arch_12!
echo    !Bold!!Hi_Cyan![03]!Reset! !clr_03! Mozilla Firefox       [!st_03!]!Reset! !arch_03!     !Bold!!Hi_Cyan![13]!Reset! !clr_13! Audacity             [!st_13!]!Reset! !arch_13!
echo    !Bold!!Hi_Cyan![04]!Reset! !clr_04! VLC Media Player      [!st_04!]!Reset! !arch_04!     !Bold!!Hi_Cyan![14]!Reset! !clr_14! GIMP (Photo Editor)  [!st_14!]!Reset! !arch_14!
echo    !Bold!!Hi_Cyan![05]!Reset! !clr_05! Notepad++             [!st_05!]!Reset! !arch_05!     !Bold!!Hi_Cyan![15]!Reset! !clr_15! LibreOffice          [!st_15!]!Reset! !arch_15!
echo    !Bold!!Hi_Cyan![06]!Reset! !clr_06! AnyDesk               [!st_06!]!Reset! !arch_06!     !Bold!!Hi_Cyan![16]!Reset! !clr_16! CPU-Z                [!st_16!]!Reset! !arch_16!
echo    !Bold!!Hi_Cyan![07]!Reset! !clr_07! Zoom Meeting          [!st_07!]!Reset! !arch_07!     !Bold!!Hi_Cyan![17]!Reset! !clr_17! HandBrake            [!st_17!]!Reset! !arch_17!
echo    !Bold!!Hi_Cyan![08]!Reset! !clr_08! Discord               [!st_08!]!Reset! !arch_08!     !Bold!!Hi_Cyan![18]!Reset! !clr_18! K-Lite Codec Pack    [!st_18!]!Reset! !arch_18!
echo    !Bold!!Hi_Cyan![09]!Reset! !clr_09! LINE PC               [!st_09!]!Reset! !arch_09!     !Bold!!Hi_Cyan![19]!Reset! !clr_19! PowerToys            [!st_19!]!Reset! !arch_19!
echo    !Bold!!Hi_Cyan![10]!Reset! !clr_10! Acrobat Reader        [!st_10!]!Reset! !arch_10!     !Bold!!Hi_Cyan![20]!Reset! !clr_20! Everything Search    [!st_20!]!Reset! !arch_20!
echo.
echo  !Bold!!Cyan!==============================================================================================!Reset!
echo   !Bold!!Bg_Green!!Hi_White! S !Reset! !Bold!!Hi_Green!START!Reset!      !Bold!!Bg_Yellow!!Black! P1..4 !Reset! !White!Profiles!Reset!   !Bold!!Bg_White!!Black! C !Reset! !White!Clear!Reset!   !Bold!!Bg_Blue!!Hi_White! R !Reset! !White!Refresh!Reset!   !Bold!!Bg_Red!!Hi_White! X !Reset! !White!Exit!Reset!
echo.

set "choice="
set /p "choice=!Bold!Select Item [!Bg_Magenta!01-20!Reset!] or [!Bg_Green!S/!Bg_Yellow!P1-4/!Bg_White!C/!Bg_Blue!R/!Bg_Red!X!Reset!]: !Reset!"
:: [FIX] ถ้ากด Enter เปล่าๆ (ไม่พิมพ์อะไร) ให้เด้งกลับไปหน้าเมนูทันที
if not defined choice goto :MAIN_MENU

if /i "%choice%"=="S" goto :START_PROCESS
if /i "%choice%"=="P1" goto :SET_PROFILE1
if /i "%choice%"=="P2" goto :SET_PROFILE2
if /i "%choice%"=="P3" goto :SET_PROFILE3
if /i "%choice%"=="P4" goto :SET_PROFILE4
if /i "%choice%"=="C" call :CLEAR_ALL & goto :MAIN_MENU
if /i "%choice%"=="R" goto :REFRESH_STATUS
if /i "%choice%"=="X" exit

if "%choice:~1%"=="" set "choice=0%choice%"
if defined sw_%choice% (
    if "!sw_%choice%!"=="0" (set "sw_%choice%=1") else (set "sw_%choice%=0")
)
goto :MAIN_MENU

:: =========================================================
::  3. LOGIC & PROFILES
:: =========================================================
:CLEAR_ALL
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do set "sw_%%i=0"
exit /b

:REFRESH_STATUS
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (set "done_%%i=0" & set "failed_%%i=0")
goto :MAIN_MENU

:SET_PROFILE1
call :CLEAR_ALL
if not exist "!Path_01!" set "sw_01=1"
if not exist "!Path_02!" set "sw_02=1"
if not exist "!Path_09!" set "sw_09=1"
if not exist "!Path_18!" set "sw_18=1"
goto :MAIN_MENU
:SET_PROFILE2
call :CLEAR_ALL
if not exist "!Path_05!" set "sw_05=1"
if not exist "!Path_06!" set "sw_06=1"
if not exist "!Path_11!" set "sw_11=1"
if not exist "!Path_16!" set "sw_16=1"
goto :MAIN_MENU
:SET_PROFILE3
call :CLEAR_ALL
if not exist "!Path_04!" set "sw_04=1"
if not exist "!Path_13!" set "sw_13=1"
if not exist "!Path_14!" set "sw_14=1"
if not exist "!Path_20!" set "sw_20=1"
goto :MAIN_MENU
:SET_PROFILE4
call :CLEAR_ALL
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (if not exist "!Path_%%i!" set "sw_%%i=1")
goto :MAIN_MENU

:: =========================================================
::  4. PROCESS MANAGER
:: =========================================================
:START_PROCESS
cls
echo. & echo  !Bg_Cyan!!Hi_White![ PROCESS ]!Reset! !Bold!!Cyan!Starting Installation...!Reset! & echo  ---------------------------------------------------

:: Check Aria2
if not exist "!ARIA2_EXE!" (
    powershell -c "irm https://github.com/aria2/aria2/releases/download/release-1.37.0/aria2-1.37.0-win-64bit-build1.zip -OutFile $env:TEMP\a.zip; Expand-Archive $env:TEMP\a.zip -Dest $env:TEMP\ax -Force; mv $env:TEMP\ax\aria2-*\aria2c.exe $env:TEMP\aria2c.exe -Force; rm $env:TEMP\a.zip -Force; rm $env:TEMP\ax -Recurse -Force" >nul 2>&1
    set "UseAria2=1"
) else ( set "UseAria2=1" )

:: Run Loop
if "!sw_01!"=="1" call :RUN 01 "7-Zip"
if "!sw_02!"=="1" call :RUN 02 "Google Chrome"
if "!sw_03!"=="1" call :RUN 03 "Mozilla Firefox"
if "!sw_04!"=="1" call :RUN 04 "VLC Media Player"
if "!sw_05!"=="1" call :RUN 05 "Notepad++"
if "!sw_06!"=="1" call :RUN 06 "AnyDesk"
if "!sw_07!"=="1" call :RUN 07 "Zoom Meeting"
if "!sw_08!"=="1" call :RUN 08 "Discord"
if "!sw_09!"=="1" call :RUN 09 "LINE PC"
if "!sw_10!"=="1" call :RUN 10 "Acrobat Reader"
if "!sw_11!"=="1" call :RUN 11 "TeamViewer"
if "!sw_12!"=="1" call :RUN 12 "OBS Studio"
if "!sw_13!"=="1" call :RUN 13 "Audacity"
if "!sw_14!"=="1" call :RUN 14 "GIMP"
if "!sw_15!"=="1" call :RUN 15 "LibreOffice"
if "!sw_16!"=="1" call :RUN 16 "CPU-Z"
if "!sw_17!"=="1" call :RUN 17 "HandBrake"
if "!sw_18!"=="1" call :RUN 18 "K-Lite Codec"
if "!sw_19!"=="1" call :RUN 19 "PowerToys"
if "!sw_20!"=="1" call :RUN 20 "Everything"

echo. & echo  !Bg_Green!!Hi_White![ DONE ]!Reset! Task Completed. & timeout /t 2 >nul & goto :MAIN_MENU

:RUN
set "ID=%~1"
set "NAME=%~2"
echo. & echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!%NAME%...!Reset!

:: [Target URL - In Scripts Folder]
set "TARGET_URL=%CLOUD_BASE%/scripts/inst_%ID%.ps1"

powershell -NoProfile -ExecutionPolicy Bypass -Command "& { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 (echo  !Bg_Green!!Hi_White![ OK ]!Reset! & set "done_%ID%=1") else (echo  !Bg_Red!!Hi_White![ FAIL ]!Reset! & set "failed_%ID%=1")
set "sw_%ID%=0"
exit /b

:: =========================================================
::  5. UTILS, COLORS, PATHS & UPDATE STATUS
:: =========================================================
:SETUP_COLORS_AND_PATHS
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do set "ESC=%%b"
set "Reset=%ESC%[0m" & set "Bold=%ESC%[1m"
set "Black=%ESC%[30m" & set "Red=%ESC%[31m" & set "Hi_Red=%ESC%[91m"
set "Green=%ESC%[32m" & set "Hi_Green=%ESC%[92m"
set "Yellow=%ESC%[33m" & set "Hi_Yellow=%ESC%[93m"
set "Blue=%ESC%[34m" & set "Hi_Blue=%ESC%[94m"
set "Magenta=%ESC%[35m" & set "Hi_Magenta=%ESC%[95m"
set "Cyan=%ESC%[36m" & set "Hi_Cyan=%ESC%[96m"
set "White=%ESC%[37m" & set "Hi_White=%ESC%[97m"
set "Bg_Black=%ESC%[40m" & set "Bg_Red=%ESC%[41m"
set "Bg_Green=%ESC%[42m" & set "Bg_Yellow=%ESC%[43m"
set "Bg_Blue=%ESC%[44m" & set "Bg_Magenta=%ESC%[45m"
set "Bg_Cyan=%ESC%[46m" & set "Bg_White=%ESC%[47m"

:: [ PATH DEFINITIONS ] P64 = x64 Path | P32 = x86 Path
set "P64_01=%ProgramFiles%\7-Zip\7z.exe"                               & set "P32_01=%ProgramFiles(x86)%\7-Zip\7z.exe"
set "P64_02=%ProgramFiles%\Google\Chrome\Application\chrome.exe"        & set "P32_02=%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe"
set "P64_03=%ProgramFiles%\Mozilla Firefox\firefox.exe"                 & set "P32_03=%ProgramFiles(x86)%\Mozilla Firefox\firefox.exe"
set "P64_04=%ProgramFiles%\VideoLAN\VLC\vlc.exe"                        & set "P32_04=%ProgramFiles(x86)%\VideoLAN\VLC\vlc.exe"
set "P64_05=%ProgramFiles%\Notepad++\notepad++.exe"                     & set "P32_05=%ProgramFiles(x86)%\Notepad++\notepad++.exe"
set "P64_06=%ProgramFiles%\AnyDesk\AnyDesk.exe"                         & set "P32_06=%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe"
set "P64_07=%AppData%\Zoom\bin\Zoom.exe"                                & set "P32_07=%ProgramFiles(x86)%\Zoom\bin\Zoom.exe"
set "P64_08=%LocalAppData%\Discord\Update.exe"                          & set "P32_08="
set "P64_09=%LocalAppData%\LINE\bin\LineLauncher.exe"                   & set "P32_09="
set "P64_10=%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe"        & set "P32_10=%ProgramFiles(x86)%\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
set "P64_11=%ProgramFiles%\TeamViewer\TeamViewer.exe"                   & set "P32_11=%ProgramFiles(x86)%\TeamViewer\TeamViewer.exe"
set "P64_12=%ProgramFiles%\obs-studio\bin\64bit\obs64.exe"              & set "P32_12=%ProgramFiles(x86)%\obs-studio\bin\32bit\obs32.exe"
set "P64_13=%ProgramFiles%\Audacity\Audacity.exe"                       & set "P32_13=%ProgramFiles(x86)%\Audacity\Audacity.exe"
set "P64_14=%ProgramFiles%\GIMP 2\bin\gimp-2.10.exe"                    & set "P32_14=%ProgramFiles(x86)%\GIMP 2\bin\gimp-2.10.exe"
set "P64_15=%ProgramFiles%\LibreOffice\program\soffice.exe"             & set "P32_15=%ProgramFiles(x86)%\LibreOffice\program\soffice.exe"
set "P64_16=%ProgramFiles%\CPUID\CPU-Z\cpuz.exe"                        & set "P32_16=%ProgramFiles(x86)%\CPUID\CPU-Z\cpuz.exe"
set "P64_17=%ProgramFiles%\HandBrake\HandBrake.exe"                     & set "P32_17=%ProgramFiles(x86)%\HandBrake\HandBrake.exe"
set "P64_18=%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe" & set "P32_18=%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC\mpc-hc.exe"
set "P64_19=%ProgramFiles%\PowerToys\PowerToys.exe"                     & set "P32_19="
set "P64_20=%ProgramFiles%\Everything\Everything.exe"                   & set "P32_20=%ProgramFiles(x86)%\Everything\Everything.exe"

for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (set "sw_%%i=0" & set "done_%%i=0" & set "failed_%%i=0" & set "clr_%%i=!Hi_White!" & set "arch_%%i=     ")
exit /b

:FIX_WINDOW
powershell -Command ^
  "$u='[DllImport(\"user32.dll\")] public static extern int GetWindowLong(IntPtr h,int n);[DllImport(\"user32.dll\")] public static extern int SetWindowLong(IntPtr h,int n,int w);[DllImport(\"user32.dll\")] public static extern bool SetWindowPos(IntPtr h,IntPtr i,int x,int y,int cx,int cy,uint f);[DllImport(\"user32.dll\")] public static extern int DeleteMenu(IntPtr h,int n,int w);[DllImport(\"user32.dll\")] public static extern IntPtr GetSystemMenu(IntPtr h,bool b);[DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow();';" ^
  "$t=Add-Type -MemberDefinition $u -Name 'Win32' -Namespace Win32 -PassThru;" ^
  "$h=$t::GetConsoleWindow();" ^
  "Add-Type -AssemblyName System.Windows.Forms;" ^
  "$s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds;" ^
  "$x=($s.Width - (100*9))/2; $y=($s.Height - (26*19))/2;" ^
  "$t::SetWindowPos($h,0,$x,$y,0,0,0x41);" ^
  "$style=$t::GetWindowLong($h,-16);" ^
  "$t::SetWindowLong($h,-16,$style -band 0xFFFEFFFF);" ^
  "$m=$t::GetSystemMenu($h,$false);" ^
  "$t::DeleteMenu($m,0xF060,0);" >nul 2>&1
exit /b

:UPDATE_STATUS
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (
    set "clr_%%i=!Bg_Red!!Hi_White!"
    set "st_%%i=   OFF  "
    set "arch_%%i=     "
    set "Path_%%i="
    
    :: [ARCH CHECK LOGIC]
    if exist "!P64_%%i!" (
        set "Path_%%i=!P64_%%i!"
        set "arch_%%i=!Hi_Yellow!(x64)!Reset!"
    ) else if exist "!P32_%%i!" (
        set "Path_%%i=!P32_%%i!"
        set "arch_%%i=!Hi_Yellow!(x86)!Reset!"
    )

    if "!sw_%%i!"=="1" ( set "clr_%%i=!Bg_Yellow!!Black!" & set "st_%%i=   ON   " )
    if defined Path_%%i ( set "clr_%%i=!Bg_Cyan!!Hi_White!" & set "st_%%i= INSTLD " )
    if "!done_%%i!"=="1" ( set "clr_%%i=!Bg_Green!!Hi_White!" & set "st_%%i=  DONE  " )
    if "!failed_%%i!"=="1" ( set "clr_%%i=!Bg_Red!!Hi_White!" & set "st_%%i= FAILED " )
)
exit /b


