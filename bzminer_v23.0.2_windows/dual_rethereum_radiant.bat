@echo off
cd /d %~dp0

:: replace 0000 with your rethereum wallet address
:: replace 1111 with your radiant wallet address
:: adjust --max_dual_autotune_drop to change how much rethereum hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

bzminer.exe -a rethereum -w 0000 -p us.vipor.net:5070 --a2 radiant --w2 1111 --p2 stratum+tcp://rxd.vipor.net:5066 --max_dual_autotune_drop 0.85 --nc 1

pause