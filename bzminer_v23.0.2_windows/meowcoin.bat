@echo off
cd /d %~dp0

:: replace 0000 with your address

:: mine to pool.rplant.xyz/
bzminer -a meowcoin -w 0000 -p stratum-eu.rplant.xyz:17078 --nc 1

pause