@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: coolpool
bzminer -a canxium -w 0000 -p ethstratum+tcp://cau.coolpool.top:16003 --nc 1

pause