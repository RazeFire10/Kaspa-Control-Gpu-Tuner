@echo off
cd /d %~dp0

:: replace 0000 with your octa wallet address
:: replace 1111 with your kaspa wallet address
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

bzminer.exe -a octa -w 0000 -p ethstratum+tcp://us.crazypool.org:5225 --a2 kaspa --w2 kaspa:1111 --p2 stratum+tcp://de.kaspa.herominers.com:1206 --max_dual_autotune_drop 0.92 --nc 1

pause