@echo off
cd /d %~dp0

:: replace 0000 with your octa wallet address
:: replace 1111 with your alph wallet address
:: adjust --max_dual_autotune_drop to change how much octa hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

bzminer.exe -a octa -w 0000 -p ethstratum+tcp://us.crazypool.org:5225 --a2 alph --w2 1111 --p2 stratum+tcp://de.alephium.herominers.com:1199 --max_dual_autotune_drop 0.92 --nc 1

pause