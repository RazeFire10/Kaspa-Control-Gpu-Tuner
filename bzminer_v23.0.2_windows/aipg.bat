@echo off
cd /d %~dp0

:: replace 0000 with your address

:: mine to herominers
bzminer -a gamepass -w 0000 -p stratum+tcp://us.aipg.herominers.com:1128 --nc 1


pause