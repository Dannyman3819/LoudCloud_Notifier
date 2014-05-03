@echo off

REM user variables
setlocal
set build=Build
set autoit=%ProgramFiles(x86)%\Autoit3\Aut2Exe\Aut2exe.exe
set autoitd=%ProgramFiles(x86)%\Autoit3\Aut2Exe\
REM set autoit=%ProgramFiles%\Autoit3\Aut2Exe\Aut2exe.exe

set version=A2
set name=LCN Notifier
set author=Daniel Blevins

set out=%build%\out\%version%

REM script dependencies
set curl=curl-7.29.0

echo Starting Build....
echo --Variables:--
echo Build directory:%build%
echo Autoit directory:%autoit%
echo Out directory:%out%
echo Version:%version%
echo Name:%name%
echo Author:%author%
echo.
pause
cls

REM check dependency
if NOT exist "%autoit%" (
echo Error make sure autoit3 is correctly installed and user variables are correct!
echo ------------Exiting------------
exit /B
)

REM if NOT exist "%CD%\%build%\Bat_To_Exe_Converter.exe" (
REM echo Error dependency 'Bat_To_Exe_Converter.exe' missing!
REM echo ------------Exiting------------
REM exit /B
REM )

echo Beginning...
echo.
echo.
rmdir /Q /S %out%
mkdir %out%

REM dir /B | findstr .bat > buildTemp.txt
REM for /F "tokens=*" %%A in (buildTemp.txt) do call:makeBat %%A
REM del buildTemp.txt

copy * %out%
dir /B | findstr .au3 > buildTemp.txt
for /F "tokens=*" %%A in (buildTemp.txt) do call:makeAu3 %%A
del /Q buildTemp.txt


mkdir %out%\%curl%\
copy %curl%\* %out%\%curl%\


del %out%\.*
rmdir %out%\Build
cd %out%
zip "%name%_%version%.zip" * -m
cd ..\..\..
echo -Finished zipping-
echo %DATE%  %TIME%
echo Package- %out%\%name%_%version%.zip
echo.

copy "%out%\%name%_%version%.zip" "%build%\Build.zip"
"%autoit%" /in %build%\Installer.au3 /out %out%\Install.exe /icon LCN.ico
del %build%\Build.zip
rmdir /Q /S %out%\%curl%\

echo.
echo.
echo --Done--
echo %DATE%  %TIME%
echo Finished Installer Package at: %out%\Install.exe
echo.

exit /B

:makeAu3
del %out%\%~1
set fileTemp=%~1
echo File- %fileTemp%
@setlocal enableextensions enabledelayedexpansion
set fileTemp=!fileTemp:~0,-4!

"!autoit!" /in !fileTemp!.au3 /out !out!\!fileTemp!.exe /icon LCN.ico

echo !out!\!fileTemp!.exe
echo.
endlocal
goto:eof
