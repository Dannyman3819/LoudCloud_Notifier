@echo off
REM user variables
setlocal


if "%*"=="" (
	endlocal
	echo Error need username and password
	pause
	Exit /B
) else (
	set uName=%1
	set pWord=%2
)

for /f %%x in ('wmic path win32_utctime get /format:list ^| findstr "="') do (
    set %%x)
set /a z=(14-100%Month%%%100)/12, y=10000%Year%%%10000-z
set /a ut=y*365+y/4-y/100+y/400+(153*(100%Month%%%100+12*z-3)+2)/5+Day-719469
set /a ut=ut*86400+100%Hour%%%100*3600+100%Minute%%%100*60+100%Second%%%100
set UNIX_TIME=%ut%
echo %UNIX_TIME% seconds have elapsed since 1970-01-01 00:00:00


curl-7.29.0\curl.exe  "https://lc.gcu.edu/learningPlatform/j_spring_security_check" -d "j_username=%uName%&j_password=%pWord%" -c "%APPDATA%\LoudCloud_Notifier\LC_Cookie" -k
curl-7.29.0\curl.exe -G "https://lc.gcu.edu/learningPlatform/user/users.html" -b "%APPDATA%\LoudCloud_Notifier\LC_Cookie" -d "operation=loggedIn" -k > "%APPDATA%\LoudCloud_Notifier\CheckUserPass.htm"

curl-7.29.0\curl.exe  "https://lc-ugrad1.gcu.edu/learningPlatform/j_spring_security_check" -d "j_username=%uName%&j_password=%pWord%" -c "%APPDATA%\LoudCloud_Notifier\UGRAD_Cookie" -k
curl-7.29.0\curl.exe -G "https://lc-ugrad1.gcu.edu/learningPlatform/user/users.html" -b "%APPDATA%\LoudCloud_Notifier\UGRAD_Cookie" -d "operation=loggedIn" -k > "%APPDATA%\LoudCloud_Notifier\UGRAD_CheckUserPass.htm"

curl-7.29.0\curl.exe  "https://lc-trad1.gcu.edu/learningPlatform/j_spring_security_check" -d "j_username=%uName%&j_password=%pWord%" -c "%APPDATA%\LoudCloud_Notifier\TRAD_Cookie" -k
curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/user/users.lc" -b "%APPDATA%\LoudCloud_Notifier\TRAD_Cookie" -d "operation=loggedIn" -k > "%APPDATA%\LoudCloud_Notifier\TRAD_CheckUserPass.htm"
