@echo off
cd /d %~dp0

:: replace 0000 with your address

:: mine to minerpool
bzminer -a neox -w 0000 -p neox-eu.minerpool.org:10059 --nc 1

:: mine to 2miners
::bzminer -a neox -w 0000 -p stratum+tcp://neox.2miners.com:4040 --nc 1

pause