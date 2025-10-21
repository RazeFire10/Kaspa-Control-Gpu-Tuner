@echo off
cd /d %~dp0

:: replace 0000 with your wallet address
:: NOTE: address may need to start with "nexellia:"

:: herominers
bzminer -a nexellia -w nexellia:0000 -p stratum+ssl://ca.nexellia.herominers.com:1143 --nc 1

pause