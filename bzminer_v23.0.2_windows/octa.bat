@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: vipor
bzminer.exe -a octa -w 0000 -p ethproxy+ssl://us.vipor.net:5104  --nc 1

:: herominers
::bzminer.exe -a octa -w 0000 -p ethstratum+tcp://us.crazypool.org:5225 --nc 1

pause