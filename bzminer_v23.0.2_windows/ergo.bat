@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: herominers
bzminer.exe -a ergo -w 0000 -p de.ergo.herominers.com:1180 --nc 1

:: mine to kryptex
::bzminer.exe -a ergo -p stratum+tcp://erg.kryptex.network:7777 -w WALLET_ADDRESS.WORKER_NAME

:: mine to flypool
::bzminer.exe -a ergo -w 0000 -p stratum-ergo.flypool.org:3333 --nc 1

:: mine to nanopool
::bzminer -a ergo -w 0000 -p ergo-us-east1.nanopool.org:11111 --nc 1

:: mine to 2miners
::bzminer -a ergo -w 0000 -p us-erg.2miners.com:8888 --nc 1

pause