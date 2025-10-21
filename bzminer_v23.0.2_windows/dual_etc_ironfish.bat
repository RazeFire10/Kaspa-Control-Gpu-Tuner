@echo off
cd /d %~dp0

:: replace 0000 with your etc wallet address
:: replace 1111 with your kaspa wallet address
:: adjust --max_dual_autotune_drop to change how much etc hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: herominers
bzminer -a etchash -w 0000 -p stratum+tcp://de.etc.herominers.com:1150 --a2 ironfish --w2 1111 --p2 stratum+tcp://us.ironfish.herominers.com:1145 --max_dual_autotune_drop 0.92 --nc 1

pause