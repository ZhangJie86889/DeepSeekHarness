@echo off
REM DeepSeek Harness - portable launcher
REM Works no matter where you unzip this folder (D:, E:, anywhere).
REM All runtime data lives in the "data" subfolder next to this .bat.
set "HARNESS=%~dp0"

REM --- Find Node.js (portable copy first, then PATH, then common installs) ---
set "NODE_EXE="
if exist "%HARNESS%node\node.exe" set "NODE_EXE=%HARNESS%node\node.exe"
if not defined NODE_EXE (
  where node >nul 2>&1 && set "NODE_EXE=node"
)
if not defined NODE_EXE (
  if exist "D:\Program Files\nodejs\node.exe" set "NODE_EXE=D:\Program Files\nodejs\node.exe"
)
if not defined NODE_EXE (
  if exist "C:\Program Files\nodejs\node.exe" set "NODE_EXE=C:\Program Files\nodejs\node.exe"
)
if not defined NODE_EXE (
  color 0C
  echo [ERROR] Node.js not found.
  echo Please keep node.exe in the "node" subfolder, or install Node.js 22+ from https://nodejs.org
  pause
  exit /b 1
)

REM --- Runtime data folder ---
set "DSH_HOME=%HARNESS%data"

cd /d "%HARNESS%"

IF "%1"=="" (
  color 0A
  echo ============================================================
  echo   DeepSeek Harness is starting...
  echo   First load takes ~20-40 seconds. Please wait, do NOT close this window.
  echo   Your browser will open automatically at: http://127.0.0.1:3080
  echo   (If it does not, just open that address manually.)
  echo   To stop: close this window or press Ctrl+C
  echo ============================================================
  REM Wait for the server, then open the browser automatically (max ~3 min)
  start /b powershell -NoProfile -WindowStyle Hidden -Command "for($i=0;$i-lt90;$i++){try{if((Invoke-WebRequest http://127.0.0.1:3080 -UseBasicParsing -TimeoutSec 2).StatusCode -eq 200){Start-Process 'http://127.0.0.1:3080';break}}catch{sleep 1}}"
  "%NODE_EXE%" node_modules\@deepseek-ai\dsh\lib\bin.js web
  if errorlevel 1 (
    color 0C
    echo.
    echo [ERROR] The server exited with an error. See messages above.
    pause
  )
) ELSE (
  "%NODE_EXE%" node_modules\@deepseek-ai\dsh\lib\bin.js %*
)
