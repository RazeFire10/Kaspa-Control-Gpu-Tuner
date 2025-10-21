@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: vipor.net
bzminer -a kylacoin -w 0000 -p stratum+tcp://pool.vipor.io:15020 --nc 1

:: mining4people
::bzminer -a kylacoin -w 0000 -p stratum+tcp://fi.mining4people.com:3449 --nc 1

:: zergpool
::bzminer -a kylacoin -w 0000 -p stratum+tcp://sha3d.na.mine.zergpool.com:5136 --nc 1

pause