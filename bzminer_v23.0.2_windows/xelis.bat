@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: huge pages can improve performance, see huge_pages.txt

:: mine to vipor
bzminer -a xelis -w 0000 -p stratum+ssl://us.vipor.net:5177 --nc 1

:: mine to herominers
::bzminer -a radiant -w 0000 -p stratum+ssl://us.xelis.herominers.com:1225 --nc 1


pause