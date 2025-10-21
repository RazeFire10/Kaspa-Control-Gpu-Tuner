@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: woolypooly
bzminer -a novo -w 0000 -p stratum+tcp://pool.woolypooly.com:3134 --nc 1

:: ekapool
::bzminer -a novo -w 0000 -p stratum+tcp://novo.us.ekapool.com:5556 --nc 1

:: supernovo
::bzminer -a novo -w 0000 -p stratum+tcp://supernovo.pro:3042 --nc 1

:: mynewmining
::bzminer -a novo -w 0000 -p stratum+tcp://pool.mynewmining.com:3091 --nc 1

:: zergpool
::bzminer -a novo -w 0000 -p stratum+tcp://sha256dt.na.mine.zergpool.com:3341 --pool_password c=NOVO --nc 1

pause