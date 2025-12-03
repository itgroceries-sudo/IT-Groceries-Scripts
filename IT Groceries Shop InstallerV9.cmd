@echo off
setlocal EnableDelayedExpansion

:: =========================================================
:: 1. GLOBAL ADMIN CHECK
:: =========================================================
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

:: =========================================================
:: 2. SETUP & CONFIGURATION
:: =========================================================
set "Ver=9.2 ^| %Date%"
title IT Groceries Shop Installer ^( Cloud Engine Ultimate ^)
mode con: cols=100 lines=25

:: --- Magic PowerShell Block (Window Lock) ---
powershell -Command ^
  "$u='[DllImport(\"user32.dll\")] public static extern int GetWindowLong(IntPtr h,int n);[DllImport(\"user32.dll\")] public static extern int SetWindowLong(IntPtr h,int n,int w);[DllImport(\"user32.dll\")] public static extern bool SetWindowPos(IntPtr h,IntPtr i,int x,int y,int cx,int cy,uint f);[DllImport(\"user32.dll\")] public static extern int DeleteMenu(IntPtr h,int n,int w);[DllImport(\"user32.dll\")] public static extern IntPtr GetSystemMenu(IntPtr h,bool b);[DllImport(\"kernel32.dll\")] public static extern IntPtr GetConsoleWindow();';" ^
  "$t=Add-Type -MemberDefinition $u -Name 'Win32' -Namespace Win32 -PassThru;" ^
  "$h=$t::GetConsoleWindow();" ^
  "Add-Type -AssemblyName System.Windows.Forms;" ^
  "$s=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds;" ^
  "$x=($s.Width - (85*9))/2; $y=($s.Height - (25*19))/2;" ^
  "$t::SetWindowPos($h,0,$x,$y,0,0,0x41);" ^
  "$style=$t::GetWindowLong($h,-16);" ^
  "$t::SetWindowLong($h,-16,$style -band 0xFFFEFFFF);" ^
  "$m=$t::GetSystemMenu($h,$false);" ^
  "$t::DeleteMenu($m,0xF060,0);" >nul 2>&1

:: --- Color Definitions ---
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

:: --- Define Paths (Check Installed) ---
set "Path_01=%ProgramFiles%\7-Zip\7z.exe"
set "Path_02=%ProgramFiles%\Google\Chrome\Application\chrome.exe"
set "Path_03=%ProgramFiles%\Mozilla Firefox\firefox.exe"
set "Path_04=%ProgramFiles%\VideoLAN\VLC\vlc.exe"
set "Path_05=%ProgramFiles%\Notepad++\notepad++.exe"
set "Path_06=%ProgramFiles(x86)%\AnyDesk\AnyDesk.exe"
set "Path_07=%AppData%\Zoom\bin\Zoom.exe"
set "Path_08=%LocalAppData%\Discord\Update.exe"
set "Path_09=%LocalAppData%\LINE\bin\LineLauncher.exe"
set "Path_10=%ProgramFiles%\Adobe\Acrobat DC\Acrobat\Acrobat.exe"
set "Path_11=%ProgramFiles%\TeamViewer\TeamViewer.exe"
set "Path_12=%ProgramFiles%\obs-studio\bin\64bit\obs64.exe"
set "Path_13=%ProgramFiles%\Audacity\Audacity.exe"
set "Path_14=%ProgramFiles%\GIMP 2\bin\gimp-2.10.exe"
set "Path_15=%ProgramFiles%\LibreOffice\program\soffice.exe"
set "Path_16=%ProgramFiles%\CPUID\CPU-Z\cpuz.exe"
set "Path_17=%ProgramFiles%\HandBrake\HandBrake.exe"
set "Path_18=%ProgramFiles(x86)%\K-Lite Codec Pack\MPC-HC64\mpc-hc64.exe"
set "Path_19=%ProgramFiles%\PowerToys\PowerToys.exe"
set "Path_20=%ProgramFiles%\Everything\Everything.exe"

:: --- Init Variables ---
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (
    set "sw_%%i=0" & set "done_%%i=0" & set "failed_%%i=0" & set "clr_%%i=!Hi_White!"
)

:: =========================================================
::  MAIN MENU ZONE
:: =========================================================
:MAIN_MENU
cls
:: --- Update Status Logic ---
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (
    if "!failed_%%i!"=="1" (
        set "clr_%%i=!Bg_Red!!Hi_White!"
        set "st_%%i= FAILED "
    ) else if "!done_%%i!"=="1" (
        set "clr_%%i=!Bg_Green!!Hi_White!"
        set "st_%%i=  DONE  "
    ) else if exist "!Path_%%i!" (
        set "clr_%%i=!Bg_Cyan!!Hi_White!"
        set "st_%%i= INSTLD "
    ) else if "!sw_%%i!"=="1" (
        set "clr_%%i=!Bg_Yellow!!Black!"
        set "st_%%i=   ON   "
    ) else (
        set "clr_%%i=!Bg_Red!!Hi_White!"
        set "st_%%i=   OFF  "
    )
)

echo.
echo  !Bold!!Cyan!====================================================================================!Reset!
echo             !Bold!!Bg_Green!!Hi_White!IT GROCERIES SHOP - ULTIMATE INSTALLER!Reset! !Bg_Magenta!!Hi_Yellow!(v%Ver%)!Reset!
echo  !Bold!!Cyan!====================================================================================!Reset!
echo.
echo    !Bold!!Hi_Cyan![01]!Reset! !clr_01! 7-Zip                [!st_01!]!Reset!      !Bold!!Hi_Cyan![11]!Reset! !clr_11! TeamViewer           [!st_11!]!Reset!
echo    !Bold!!Hi_Cyan![02]!Reset! !clr_02! Google Chrome        [!st_02!]!Reset!      !Bold!!Hi_Cyan![12]!Reset! !clr_12! OBS Studio           [!st_12!]!Reset!
echo    !Bold!!Hi_Cyan![03]!Reset! !clr_03! Mozilla Firefox      [!st_03!]!Reset!      !Bold!!Hi_Cyan![13]!Reset! !clr_13! Audacity             [!st_13!]!Reset!
echo    !Bold!!Hi_Cyan![04]!Reset! !clr_04! VLC Media Player     [!st_04!]!Reset!      !Bold!!Hi_Cyan![14]!Reset! !clr_14! GIMP (Photo Editor)  [!st_14!]!Reset!
echo    !Bold!!Hi_Cyan![05]!Reset! !clr_05! Notepad++            [!st_05!]!Reset!      !Bold!!Hi_Cyan![15]!Reset! !clr_15! LibreOffice          [!st_15!]!Reset!
echo    !Bold!!Hi_Cyan![06]!Reset! !clr_06! AnyDesk              [!st_06!]!Reset!      !Bold!!Hi_Cyan![16]!Reset! !clr_16! CPU-Z                [!st_16!]!Reset!
echo    !Bold!!Hi_Cyan![07]!Reset! !clr_07! Zoom Meeting         [!st_07!]!Reset!      !Bold!!Hi_Cyan![17]!Reset! !clr_17! HandBrake            [!st_17!]!Reset!
echo    !Bold!!Hi_Cyan![08]!Reset! !clr_08! Discord              [!st_08!]!Reset!      !Bold!!Hi_Cyan![18]!Reset! !clr_18! K-Lite Codec Pack    [!st_18!]!Reset!
echo    !Bold!!Hi_Cyan![09]!Reset! !clr_09! LINE PC              [!st_09!]!Reset!      !Bold!!Hi_Cyan![19]!Reset! !clr_19! PowerToys            [!st_19!]!Reset!
echo    !Bold!!Hi_Cyan![10]!Reset! !clr_10! Acrobat Reader       [!st_10!]!Reset!      !Bold!!Hi_Cyan![20]!Reset! !clr_20! Everything Search    [!st_20!]!Reset!
echo.
echo  !Bold!!Cyan!====================================================================================!Reset!
echo   !Bold!!Bg_Green!!Hi_White! S !Reset! !Bold!!Hi_Green!START!Reset!     !Bold!!Bg_Yellow!!Black! P1..4 !Reset! !White!Profiles!Reset!   !Bold!!Bg_White!!Black! C !Reset! !White!Clear!Reset!   !Bold!!Bg_Blue!!Hi_White! R !Reset! !White!Refresh!Reset!   !Bold!!Bg_Red!!Hi_White! X !Reset! !White!Exit!Reset!
echo.

set /p "choice=!Bold!Select Item [!Bg_Magenta!01-20!Reset!] or [!Bg_Green!S/!Bg_Yellow!P1-4/!Bg_White!C/!Bg_Blue!R/!Bg_Red!X!Reset!]: !Reset!"

if /i "%choice%"=="S" goto :START_PROCESS
if /i "%choice%"=="P1" goto :SET_PROFILE1
if /i "%choice%"=="P2" goto :SET_PROFILE2
if /i "%choice%"=="P3" goto :SET_PROFILE3
if /i "%choice%"=="P4" goto :SET_PROFILE4
if /i "%choice%"=="C" goto :CLEAR_ALL
if /i "%choice%"=="R" goto :REFRESH_STATUS
if /i "%choice%"=="X" exit

:: Auto-Pad (1->01)
if "%choice:~1%"=="" set "choice=0%choice%"

if defined sw_%choice% (
    if "!sw_%choice%!"=="0" (set "sw_%choice%=1") else (set "sw_%choice%=0")
)
goto :MAIN_MENU

:: =========================================================
:: LOGIC CONTROL
:: =========================================================
:CLEAR_ALL
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do set "sw_%%i=0"
goto :MAIN_MENU

:REFRESH_STATUS
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (
    set "done_%%i=0" & set "failed_%%i=0"
)
goto :MAIN_MENU

:: --- PROFILES ---
:SET_PROFILE1
:: Basic (1, 2, 9, 18)
call :CLEAR_ALL_SILENT
if not exist "!Path_01!" set "sw_01=1"
if not exist "!Path_02!" set "sw_02=1"
if not exist "!Path_09!" set "sw_09=1"
if not exist "!Path_18!" set "sw_18=1"
goto :MAIN_MENU

:SET_PROFILE2
:: Admin (5, 6, 11, 16)
call :CLEAR_ALL_SILENT
if not exist "!Path_05!" set "sw_05=1"
if not exist "!Path_06!" set "sw_06=1"
if not exist "!Path_11!" set "sw_11=1"
if not exist "!Path_16!" set "sw_16=1"
goto :MAIN_MENU

:SET_PROFILE3
:: Media (4, 13, 14, 20)
call :CLEAR_ALL_SILENT
if not exist "!Path_04!" set "sw_04=1"
if not exist "!Path_13!" set "sw_13=1"
if not exist "!Path_14!" set "sw_14=1"
if not exist "!Path_20!" set "sw_20=1"
goto :MAIN_MENU

:SET_PROFILE4
:: Select All
call :CLEAR_ALL_SILENT
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do (
    if not exist "!Path_%%i!" set "sw_%%i=1"
)
goto :MAIN_MENU

:CLEAR_ALL_SILENT
for %%i in (01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20) do set "sw_%%i=0"
exit /b

:: =========================================================
:: PROCESS MANAGER
:: =========================================================
:START_PROCESS
cls
echo.
echo  !Bg_Cyan!!Hi_White![ PROCESS ]!Reset! !Bold!!Cyan!Starting Installation...!Reset!
echo  ---------------------------------------------------

:: กำหนด Base URL ของสคริปต์บน Github
set "CLOUD_BASE=https://raw.githubusercontent.com/itgroceries-sudo/IT-Groceries-Scripts/refs/heads/main/scripts"

if "!sw_01!"=="1" call :INST_01
if "!sw_02!"=="1" call :INST_02
if "!sw_03!"=="1" call :INST_03
if "!sw_04!"=="1" call :INST_04
if "!sw_05!"=="1" call :INST_05
if "!sw_06!"=="1" call :INST_06
if "!sw_07!"=="1" call :INST_07
if "!sw_08!"=="1" call :INST_08
if "!sw_09!"=="1" call :INST_09
if "!sw_10!"=="1" call :INST_10
if "!sw_11!"=="1" call :INST_11
if "!sw_12!"=="1" call :INST_12
if "!sw_13!"=="1" call :INST_13
if "!sw_14!"=="1" call :INST_14
if "!sw_15!"=="1" call :INST_15
if "!sw_16!"=="1" call :INST_16
if "!sw_17!"=="1" call :INST_17
if "!sw_18!"=="1" call :INST_18
if "!sw_19!"=="1" call :INST_19
if "!sw_20!"=="1" call :INST_20

echo.
echo  ---------------------------------------------------
echo  !Bg_Green!!Hi_White![ DONE ]!Reset! !Bold!!Green!All tasks completed.!Reset!
echo  Returning to menu...
timeout /t 3 >nul
goto :MAIN_MENU

:: =========================================================
:: CLOUD SUBROUTINES (01-20)
:: =========================================================

:INST_01
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!7-Zip...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_01.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 (
    echo  !Bg_Green!!Hi_White![ SUCCESS ]!Reset!
    set "done_01=1" & set "failed_01=0"
) else (
    echo  !Bg_Red!!Hi_White![ FAILED ]!Reset!
    set "done_01=0" & set "failed_01=1"
)
set "sw_01=0"
exit /b

:INST_02
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Google Chrome...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_02.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_02=1" & set "failed_02=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_02=0" & set "failed_02=1" )
set "sw_02=0" & exit /b

:INST_03
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Firefox...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_03.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_03=1" & set "failed_03=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_03=0" & set "failed_03=1" )
set "sw_03=0" & exit /b

:INST_04
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!VLC...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_04.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_04=1" & set "failed_04=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_04=0" & set "failed_04=1" )
set "sw_04=0" & exit /b

:INST_05
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Notepad++...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_05.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_05=1" & set "failed_05=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_05=0" & set "failed_05=1" )
set "sw_05=0" & exit /b

:INST_06
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!AnyDesk...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_06.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_06=1" & set "failed_06=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_06=0" & set "failed_06=1" )
set "sw_06=0" & exit /b

:INST_07
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Zoom...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_07.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_07=1" & set "failed_07=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_07=0" & set "failed_07=1" )
set "sw_07=0" & exit /b

:INST_08
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Discord...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_08.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_08=1" & set "failed_08=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_08=0" & set "failed_08=1" )
set "sw_08=0" & exit /b

:INST_09
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!LINE...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_09.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_09=1" & set "failed_09=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_09=0" & set "failed_09=1" )
set "sw_09=0" & exit /b

:INST_10
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Acrobat Reader...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_10.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_10=1" & set "failed_10=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_10=0" & set "failed_10=1" )
set "sw_10=0" & exit /b

:INST_11
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!TeamViewer...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_11.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_11=1" & set "failed_11=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_11=0" & set "failed_11=1" )
set "sw_11=0" & exit /b

:INST_12
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!OBS Studio...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_12.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_12=1" & set "failed_12=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_12=0" & set "failed_12=1" )
set "sw_12=0" & exit /b

:INST_13
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Audacity...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_13.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_13=1" & set "failed_13=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_13=0" & set "failed_13=1" )
set "sw_13=0" & exit /b

:INST_14
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!GIMP...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_14.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_14=1" & set "failed_14=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_14=0" & set "failed_14=1" )
set "sw_14=0" & exit /b

:INST_15
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!LibreOffice...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_15.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_15=1" & set "failed_15=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_15=0" & set "failed_15=1" )
set "sw_15=0" & exit /b

:INST_16
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!CPU-Z...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_16.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_16=1" & set "failed_16=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_16=0" & set "failed_16=1" )
set "sw_16=0" & exit /b

:INST_17
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!HandBrake...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_17.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_17=1" & set "failed_17=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_17=0" & set "failed_17=1" )
set "sw_17=0" & exit /b

:INST_18
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!K-Lite Codec...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_18.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_18=1" & set "failed_18=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_18=0" & set "failed_18=1" )
set "sw_18=0" & exit /b

:INST_19
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!PowerToys...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_19.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_19=1" & set "failed_19=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_19=0" & set "failed_19=1" )
set "sw_19=0" & exit /b

:INST_20
echo.
echo  !Bg_Yellow!!Black![ CLOUD ]!Reset! !Hi_Yellow!Everything...!Reset!
set "TARGET_URL=%CLOUD_BASE%/inst_20.ps1"
powershell -NoProfile -Command "& { try { irm $env:TARGET_URL | iex } catch { exit 1 } }"
if %errorlevel%==0 ( echo !Bg_Green!!Hi_White![ SUCCESS ]!Reset! & set "done_20=1" & set "failed_20=0" ) else ( echo !Bg_Red!!Hi_White![ FAILED ]!Reset! & set "done_20=0" & set "failed_20=1" )
set "sw_20=0" & exit /b