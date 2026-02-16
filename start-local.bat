@echo off
setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "BIN_DIR=%SCRIPT_DIR%bin"
set "CONFIG_FILE=%SCRIPT_DIR%configs\config.local.yaml"

if not "%~1"=="" set "CONFIG_FILE=%~1"

if not exist "%CONFIG_FILE%" (
  echo Config file not found: %CONFIG_FILE%
  exit /b 1
)

set "ARCH=%PROCESSOR_ARCHITECTURE%"
set "BIN="

if /I "%ARCH%"=="ARM64" (
  if exist "%BIN_DIR%\forerouter-windows-arm64.exe" (
    set "BIN=%BIN_DIR%\forerouter-windows-arm64.exe"
  )
)

if "%BIN%"=="" (
  if exist "%BIN_DIR%\forerouter-windows-amd64.exe" (
    set "BIN=%BIN_DIR%\forerouter-windows-amd64.exe"
  )
)

if "%BIN%"=="" (
  echo Binary not found in: %BIN_DIR%
  echo Expected one of:
  echo   forerouter-windows-amd64.exe
  echo   forerouter-windows-arm64.exe
  exit /b 1
)

echo Starting Forerouter in local mode
echo Binary : %BIN%
echo Config : %CONFIG_FILE%

"%BIN%" --mode=local --config "%CONFIG_FILE%"
