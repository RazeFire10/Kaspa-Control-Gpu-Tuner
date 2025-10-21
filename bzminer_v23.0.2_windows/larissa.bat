@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: mining4people
bzminer -a larissa -w 0000 -p ethstratum+ssl://na.mining4people.com:23344 --nc 1

pause