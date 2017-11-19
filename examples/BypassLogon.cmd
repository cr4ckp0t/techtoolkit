@echo off
:begin
set /p genshare=Type the Computer Name or q to quit: 
if %genshare%==q goto end
reg add "\\%genshare%\hklm\software\microsoft\windows nt\currentversion\winlogon" /v ForceAutoLogon /d 0 /f
pause
reg add "\\%genshare%\hklm\software\microsoft\windows nt\currentversion\winlogon" /v ForceAutoLogon /d 1 /f
goto begin
:end