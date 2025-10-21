@echo off
cd /d %~dp0

:: replace 0000 with your address

:: mine to kryptex
bzminer -a xna -p stratum+tcp://xna.kryptex.network:7777 -w WALLET_ADDRESS.WORKER_NAME --nc 1

:: mine to rplant
::bzminer -a xna -w 0000 -p us.vipor.net:5090 --nc 1


pause