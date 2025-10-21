@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: mine to rxd.vipor
bzminer -a radiant -w 0000 -p stratum+tcp://rxd.vipor.net:5066 --nc 1

:: mine to woolypooly
::bzminer -a radiant -w 0000 -p stratum+tcp://pool.us.woolypooly.com:3122 --nc 1


pause