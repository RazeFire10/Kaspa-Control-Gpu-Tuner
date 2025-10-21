@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: wooly
bzminer.exe -a blocx -w 0000 -p pool.woolypooly.com:3148 --nc 1

pause