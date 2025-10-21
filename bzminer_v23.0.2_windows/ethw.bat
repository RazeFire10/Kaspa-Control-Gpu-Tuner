@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: mine to woolypooly
bzminer.exe -a ethw -w 0000 -p ethproxy+tcp://pool.woolypooly.com:3096 --nc 1

:: mine to 2miners
::bzminer -a ethw -w 0000 -p ethstratum+tcp://ethw.2miners.com:2020 --nc 1

pause