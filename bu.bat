@echo off
setlocal

:: Variables
set "srcDir=C:\Users\ThinkOpen\AppData\Roaming\Electronic Arts\Dark Age of Camelot\eden"
set "toDir=C:\dev\DAoC\eden\backup\eden"
:: for /f %%i in ('openssl rand -hex 16') do set "random_string=%%i"

:: Check if the destination folder already exists, otherwise create it
if not exist "%toDir%" mkdir "%toDir%"

:: Move the directory and overwrite everything
xcopy /y /s /e "%srcDir%" "%toDir%"

echo Copy Done.

git add .
git commit -m "back up"
git push

endlocal