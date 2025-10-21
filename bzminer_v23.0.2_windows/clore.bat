@echo off
cd /d %~dp0

:: replace 0000 with your address

:: mine to kryptex
bzminer -a clore -p stratum+tcp://clore.kryptex.network:7777 -w WALLET_ADDRESS.WORKER_NAME --nc 1

:: mine to rplant
::bzminer -a clore -w 0000 -p stratum+ssl://stratum-eu.rplant.xyz:17083 --nc 1


pause