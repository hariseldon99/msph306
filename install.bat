@echo off
setlocal

set "ANACONDA_INSTALLER_NAME=Anaconda3-2024.10-1-Windows-x86_64.exe"
set "DESK_ICO=%USERPROFILE%\Desktop\Anaconda Navigator.lnk"
set "ANACONDA_INST_DIR=C:\path\to\installer\directory"
set "PYVER=3.10"
set "REPONAME=MSPH306"

REM Function to create desktop entry
:create_desktop_entry
(
echo [InternetShortcut]
echo URL=file:///%~dp0%ANACONDA_INST_DIR%/%ANACONDA_INSTALLER_NAME%
echo IconFile=%USERPROFILE%\anaconda3\Menu\anaconda.ico
echo IconIndex=0
) > "%DESK_ICO%"

icacls "%DESK_ICO%" /grant:r everyone:(OI)(CI)F
goto :eof

REM Main script execution
echo Starting %ANACONDA_INSTALLER_NAME% Installation
%ANACONDA_INST_DIR%\%ANACONDA_INSTALLER_NAME% /S /InstallationType=AllUsers /D=%USERPROFILE%\anaconda3

%USERPROFILE%\anaconda3\Scripts\conda.exe init
%USERPROFILE%\anaconda3\Scripts\conda.exe config --set auto_activate_base false

echo Creating Desktop icon @ %DESK_ICO% and copying MSPH306 git repo to %USERPROFILE%
call :create_desktop_entry
mkdir "%USERPROFILE%\%REPONAME%"
icacls "%USERPROFILE%\%REPONAME%" /grant:r everyone:(OI)(CI)F
icacls "%USERPROFILE%\anaconda3" /grant:r everyone:(OI)(CI)F
xcopy /E /H /I /Y "%~dp0*" "%USERPROFILE%\%REPONAME%" /EXCLUDE:%ANACONDA_INSTALLER_NAME%

echo Installation and desktop icon creation complete!

endlocal

