@echo off
setlocal

:: Variables
set "srcDir=C:\dev\DAoC\eden\backup\eden"
set "toDir=%USERPROFILE%\AppData\Roaming\Electronic Arts\Dark Age of Camelot\eden"

:: Check if the destination folder already exists, otherwise create it
if not exist "%toDir%" mkdir "%toDir%"

:: Move the directory and overwrite everything
xcopy /y /s /e "%srcDir%" "%toDir%"

echo Copy Done.

endlocal
