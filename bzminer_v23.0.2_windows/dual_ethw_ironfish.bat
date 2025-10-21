@echo off
cd /d %~dp0

:: replace 0000 with your ethw wallet address
:: replace 1111 with your ironfish wallet address
:: adjust --max_dual_autotune_drop to change how much ethw hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: 2miners + herominers
bzminer -a ethw -w 0000 -pethstratum+tcp://ethw.2miners.com:2020 --a2 ironfish --w2 1111 --p2 stratum+tcp://us.ironfish.herominers.com:1145 --max_dual_autotune_drop 0.92 --nc 1


pause