@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: mine to dragonpool
bzminer -a woodcoin -w 0000 -p stratum+tcp://dragonpool.vip:5233 --pool_password c=LOG,d=1,ID=rig_name --nc 1

pause