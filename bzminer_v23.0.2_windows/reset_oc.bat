@echo off
cd /d %~dp0

:: May need Admin/Root privileges
bzminer --no_watchdog --oc_reset_all

pause