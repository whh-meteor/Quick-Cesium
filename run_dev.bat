@echo off
setlocal
cd /d %~dp0
call conda.bat activate qgis-qml-dev
python .\src\main.py
endlocal
