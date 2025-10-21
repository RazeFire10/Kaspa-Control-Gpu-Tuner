@echo off
cd /d %~dp0

:: replace 0000 with your octa wallet address
:: replace 1111 with your ironfish wallet address
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

bzminer.exe -a octa -w 0000 -p ethstratum+tcp://us.crazypool.org:5225 --a2 ironfish --w2 1111 --p2 stratum+tcp://iron.fpmp.net:8888 --max_dual_autotune_drop 0.92 --nc 1

pause