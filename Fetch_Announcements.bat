@echo off
REM user variables

if "%*"=="" (
	set Class1="a3ba3bfc-8b74-4f86-8ef1-4576345b66ca" REM ENG
	set Class2="9a5769f0-ac0a-4089-9ea7-9a922f94c295" REM PSY
	set Class3="cb60a800-503d-420e-bee2-b8a65cc9fcf2" REM MAT
	set Class4="d16dfd79-74d2-4d46-a186-d38b157f1c8e" REM PHI
	
	set uName="dblevins1"
	set pWord="Canyon85017"
	REM ENG class code
) else (
	set Class1="%1"
	set Class2="%2"
	set Class3="%3"
	set Class4="%4"
	
	set uName="%5"
	set pWord="%6"
)

for /f %%x in ('wmic path win32_utctime get /format:list ^| findstr "="') do (
    set %%x)
set /a z=(14-100%Month%%%100)/12, y=10000%Year%%%10000-z
set /a ut=y*365+y/4-y/100+y/400+(153*(100%Month%%%100+12*z-3)+2)/5+Day-719469
set /a ut=ut*86400+100%Hour%%%100*3600+100%Minute%%%100*60+100%Second%%%100
set UNIX_TIME=%ut%
echo %UNIX_TIME% seconds have elapsed since 1970-01-01 00:00:00


curl-7.29.0\curl.exe  "https://lc-trad1.gcu.edu/learningPlatform/j_spring_security_check" -d "j_username=%uName%&j_password=%pWord%" -c "Temp\LC_Cookie" -k
curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/user/users.lc" -b "Temp\LC_Cookie" -d "operation=loggedIn&classId=%Class1%#/learningPlatform/announcement/announcement.lc?operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements_Page1.htm
curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/announcement/announcement.lc" -b "Temp\LC_Cookie" -d "operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements1.htm

curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/user/users.lc" -b "Temp\LC_Cookie" -d "operation=loggedIn&classId=%Class2%#/learningPlatform/announcement/announcement.lc?operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements_Page2.htm
curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/announcement/announcement.lc" -b "Temp\LC_Cookie" -d "operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements2.htm

curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/user/users.lc" -b "Temp\LC_Cookie" -d "operation=loggedIn&classId=%CLass3%#/learningPlatform/announcement/announcement.lc?operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements_Page3.htm
curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/announcement/announcement.lc" -b "Temp\LC_Cookie" -d "operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements3.htm

curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/user/users.lc" -b "Temp\LC_Cookie" -d "operation=loggedIn&classId=%Class4%#/learningPlatform/announcement/announcement.lc?operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements_Page4.htm
curl-7.29.0\curl.exe -G "https://lc-trad1.gcu.edu/learningPlatform/announcement/announcement.lc" -b "Temp\LC_Cookie" -d "operation=searchClassAnnouncements&c=prepareClassAnnouncement&t=messagesMenuOption&tempDate=%UNIX_TIME%" -k > Temp\Announcements4.htm


REM del LC_Cookie

