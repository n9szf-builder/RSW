@echo off
rem MR Print Files - Windows launcher. Keep this file next to "MR Print Files.py".
title MR Print Files
cd /d "%~dp0"

where py >nul 2>nul
if not errorlevel 1 goto usepy
where python >nul 2>nul
if not errorlevel 1 goto usepython

echo.
echo Python 3 was not found on this computer.
echo Install it from https://www.python.org/downloads/ and tick
echo "Add python.exe to PATH" on the first screen. Then start this file again.
goto done

:usepy
py -3 "MR Print Files.py" %*
goto done

:usepython
python "MR Print Files.py" %*

:done
echo.
pause
