@echo off
setlocal

REM Define the paths (adjust as necessary)
set "sourcePath=../GUI/bin/Release/net8.0-windows"
set "templateWix=ProductTemplate.xs"
set "templateOutWix=Product.xs"

REM Run the PowerShell script
call powershell.exe -ExecutionPolicy Bypass -File "%~dp0GenerateWiXEntries.ps1" -sourcePath "%sourcePath%" -templateWix "%templateWix%" -templateOutWix "%templateOutWix%"

endlocal
