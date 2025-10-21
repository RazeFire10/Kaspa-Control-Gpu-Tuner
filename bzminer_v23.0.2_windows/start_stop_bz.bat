@echo off
cd /d %~dp0

:: Stop bz (bz continues running but stops mining)
curl http://localhost:4014/rig_command?command=stop

:: Start bz (bz reconnects to the pools and starts mining again)
::curl http://localhost:4014/rig_command?command=start

pause