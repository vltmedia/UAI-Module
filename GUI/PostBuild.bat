@echo off
setlocal

REM Get the build path from the first argument (e.g., %1 passed from Visual Studio as $(ProjectDir))
set "buildPath=%~1"
set "runtimesPath=%buildPath%\runtimes"

REM Check if the initial runtimesPath exists, if not change to a new path
if not exist "%runtimesPath%" (
    echo Initial runtimesPath does not exist. Changing to new path.
    set "runtimesPath=%buildPath%\runtimes"
)

REM Check if the build path is provided
if "%buildPath%"=="" (
    echo Error: buildPath parameter is missing.
    exit /b 1
)

REM Determine the OS platform (assuming Windows since this is a batch script)
set "osPlatform=win"

REM Determine the architecture (x64, x86, arm, arm64) using environment variables
set "osArchitecture="
if "%PROCESSOR_ARCHITECTURE%"=="AMD64" set "osArchitecture=x64"
if "%PROCESSOR_ARCHITECTURE%"=="x86" set "osArchitecture=x86"
if "%PROCESSOR_ARCHITECTURE%"=="ARM64" set "osArchitecture=arm64"
if "%PROCESSOR_ARCHITECTURE%"=="ARM" set "osArchitecture=arm"


echo OS Architecture: %osArchitecture%
REM Check if the architecture was detected
if "%osArchitecture%"=="" (
    echo Unsupported Architecture.
    exit /b 1
)

REM Combine platform and architecture to form the target runtime (e.g., win-x64)
set "targetRuntime=%osPlatform%-%osArchitecture%"
echo Target runtime: %targetRuntime%

REM Check if the runtimes directory exists
if not exist "%runtimesPath%" (
    echo The runtimes directory does not exist at path: %runtimesPath%
    exit /b 0
)

REM Delete all folders in runtimes that don't match the target runtime
for /d %%D in ("%runtimesPath%\*") do (
    if /i not "%%~nxD"=="%targetRuntime%" (
        echo Deleting non-matching runtime folder: %%~nxD
        rmdir /s /q "%%D"
    )
)

echo Cleanup complete.
endlocal
exit /b 0
