@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: vipor.net
bzminer -a rethereum -w 0000 -p us.vipor.net:5070 --nc 1

:: mining4people
::bzminer -a rethereum -w 0000 -p de.mining4people.com:3454 --nc 1

:: ekapool
::bzminer -a rethereum -w 0000 -p rth.us.ekapool.com:18896 --nc 1

pause