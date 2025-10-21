@echo off
cd /d %~dp0

:: zil can be mined by itself, in which case the gpu will sit idle while it waits for the zil window
:: zil can be mined with any other algo. When the zil window starts, all algos (except zil) pause until the zil window finishes, see dual_zil.bat
:: zil can also be mined with a dual combo, eg. zil + {eth + kas}, see zil_tri.bat

:: replace 0000 with your zil wallet

:: flexpool
bzminer.exe -a zil -w 0000 -p zmp://zil.flexpool.io

:: shardpool
::bzminer.exe -a zil -w 0000 -p zmp+tcp://us1-zil.shardpool.io:3333

read -p "Press [Enter] key to start continue..."