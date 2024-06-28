@echo off
cls

title Mini CLI

:menu
cls
echo.
echo.
echo [107m[32m Mini CLI [0m
echo.
echo 1 - Reset DHCP ([92mDynamic ONLY - Get new Random IP[0m)
echo [93m(Fix any issues with Connections and Etc.)[0m
echo.
echo 2 - Network Ping ([92mAs much as you want[0m)
echo.
echo 3 - Browser Clear Cache ([92mClear any browser cache[WIP][0m)
echo.
echo 4 - Speed Test ([92mBy Speedtest.net[0m)
echo.
echo 5 - Set DNS Manually ([92mYour DNS [WIP][0m)
echo.
echo 6 - Exit
echo.
echo [107m[30m*Notice: Blank entries will terminate the process.[0m
echo.
set /P opNum=[92mOption[0m: 
echo.
echo [93m Created by h03ein72 @2024[0m

rem Variables
set pingMaxCount=30
set pingMinCount=5
set defaultIP=8.8.8.8

rem Statements
if %opNum% gtr 6 goto wrongNavError
if %opNum% lss 1 goto wrongNavError
if %opNum%==1 goto reset
if %opNum%==2 goto pingOptions
if %opNum%==3 goto browserClearCacheOptions
if %opNum%==4 goto speedTest
if %opNum%==5 goto dnsOptions
if %opNum%==6 goto eof

rem Errors
:wrongNavError
echo Error:
echo Wrong Number!
timeout /t 2 >nul
cls
goto menu

:manyPingsError
echo Error:
echo Ex. Between 15 to 30.
timeout /t 2 >nul
cls
goto menu

:reset
ipconfig/release
ipconfig/flushdns
ipconfig/renew
cls
goto menu


:pingOptions
echo.
set /p customPing=[92mDo you have custom IP [y/n][0m: 
if %customPing%==y goto customPingNetwork
if %customPing%==n goto howManyPings

:customPingNetwork
echo.
echo Enter real IP Address[192.168.x.x]...
echo.
set /p IP=[92mYour IP[0m: 
set defaultIP=%IP%
goto howManyPings

:howManyPings
echo.
set /P pingCount=[92mHow Many Times [5~30][0m: 
if %pingCount% gtr %pingMaxCount% goto manyPingsError
if %pingCount% lss %pingMinCount% goto manyPingsError
goto pingNetwork

:pingNetwork
ping %defaultIP% -n %pingCount%
pause
cls
goto menu

:speedTest
call %~dp0\assets\libraries\speedtest.exe
pause
cls
goto menu

:dnsOptions
echo.
echo [91m[wip] beta for now.[0m
echo Feel free to ENTER `n` in order to CANCEL the process.
echo.
set /P DNS1=[92mPrimary DNS Server[0m: 
if %DNS1%==n goto menu
echo.
set /P DNS2=[92mSecondary DNS Server[0m: 
if %DNS2%==n goto menu
echo.
set /P connectionName=[92mWhat is your connection name[0m? 
if %connectionName%==n goto menu
echo.
echo Your enteries: (Primary DNS: %DNS1%, Secondary DNS: %DNS2%, Connection Name: %connectionName%)
set /P setDNSOrNot=[92mAre you ready to set DNS [y/n/] [0m: 
if %setDNSOrNot%==n goto menu
if %setDNSOrNot%==y goto setdns

:setdns
netsh interface ipv4 add dns %connectionName% address=%DNS1% index=1
netsh interface ipv4 add dns %connectionName% address=%DNS2% index=2
ipconfig/flushdns
pause
cls
goto menu

:appsOptions
echo.
echo 1 - Callbook
echo.
echo 2 - Support
echo. 
set /p customApps=[92mWhich one of these section you're working in[0m? 
if %customApps%==1 goto openCallbookApps
if %customApps%==2 goto openSupportApps

:browserClearCacheOptions
echo.
echo [91m[wip] beta for now.[0m
echo * NOTICE: May LOST Your BROWSER Files FOREVER!
echo.
echo 1 - Google Chrome
echo.
echo 2 - Mozilla Firefox
rem echo.
rem echo 3 - Microsoft Edge
echo.
set /P whichBrowser=[92mWhich browser do you want to clear[0m: 
if %whichBrowser%==1 goto chrome
if %whichBrowser%==2 goto firefox
if %whichBrowser%==3 goto iexplorer

:chrome
erase "%LOCALAPPDATA%\Google\Chrome\User Data\*.*" /f /s /q
for /D %%i in ("%LOCALAPPDATA%\Google\Chrome\User Data\*") do RD /S /Q "%%i"
goto menu

:firefox
taskkill /im "firefox.exe"
set DataDir=C:\Users\%USERNAME%\AppData\Local\Mozilla\Firefox\Profiles
del /q /s /f "%DataDir%"
rd /s /q "%DataDir%"
for /d %%x in (C:\Users\%USERNAME%\AppData\Roaming\Mozilla\Firefox\Profiles\*) do del /q /s /f %%x\*sqlite
goto menu

rem :iexplorer
rem RunDll32.exe InetCpl.cpl,ClearMyTracksByProcess 8
rem erase "%LOCALAPPDATA%\Microsoft\Windows\Tempor~1\*.*" /f /s /q
rem for /D %%i in ("%LOCALAPPDATA%\Microsoft\Windows\Tempor~1\*") do RD /S /Q "%%i"
rem goto menu