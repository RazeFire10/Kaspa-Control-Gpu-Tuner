@echo off
cd /d %~dp0

:: replace 0000 with your ethw wallet address
:: replace 1111 with your radiant wallet address
:: adjust --max_dual_autotune_drop to change how much ethw hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: ethw + radiant
bzminer -a ethw -w 0000 -p ethproxy+tcp://pool.woolypooly.com:3096 --a2 radiant --w2 1111 --p2 stratum+tcp://pool.us.woolypooly.com:3122 --max_dual_autotune_drop 0.92 --nc 1

pause