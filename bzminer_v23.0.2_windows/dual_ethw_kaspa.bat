@echo off
cd /d %~dp0

:: replace 0000 with your ethw wallet address
:: replace kaspa:1111 with your kaspa wallet address
:: NOTE: kaspa address needs to start with "kaspa:"
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: eth + kaspa (pool)
bzminer -a ethw -w 0000 -p ethproxy+tcp://pool.woolypooly.com:3096 --a2 kaspa --w2 kaspa:1111 --p2 stratum+tcp://pool.woolypooly.com:3112 --max_dual_autotune_drop 0.92 --nc 1

:: eth + kaspa (solo)
::bzminer -a ethw -w 0000 -p ethproxy+tcp://pool.woolypooly.com:3096 --a2 kaspa --w2 kaspa:1111 --p2 solo+tcp://127.0.0.1:16110 --max_dual_autotune_drop 0.92 --nc 1

pause