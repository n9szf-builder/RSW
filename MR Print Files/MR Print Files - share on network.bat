@echo off
rem MR Print Files - Windows launcher that shares it on the network.
rem Other computers browse to the address this window shows, e.g. http://192.168.1.50:8765
title MR Print Files - shared on the network
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
py -3 "MR Print Files.py" --share %*
goto done

:usepython
python "MR Print Files.py" --share %*

:done
echo.
pause
