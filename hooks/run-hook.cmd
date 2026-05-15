@echo off
setlocal enabledelayedexpansion

REM Cross-platform polyglot: find bash (Git for Windows) and execute the session-start script
REM This file can be called from either cmd.exe or bash

set "BASH="
for %%p in (
    "C:\Program Files\Git\bin\bash.exe"
    "C:\Program Files (x86)\Git\bin\bash.exe"
    "%LOCALAPPDATA%\Programs\Git\bin\bash.exe"
) do (
    if exist %%p set "BASH=%%~p"
)

if not defined BASH (
    where bash >nul 2>&1 && set "BASH=bash"
)

if defined BASH (
    set "SCRIPT_DIR=%~dp0"
    "%BASH%" -c 'exec "%SCRIPT_DIR:\=\\%session-start" "$@"' -- %*
) else (
    echo [react-pipeline] WARNING: bash not found, cannot run SessionStart hook >&2
    exit 0
)
