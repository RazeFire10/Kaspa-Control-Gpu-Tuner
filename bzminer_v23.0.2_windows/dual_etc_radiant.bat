@echo off
cd /d %~dp0

:: replace 0000 with your etc wallet address
:: replace 1111 with your radiant wallet address
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: etc + radiant
bzminer -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 radiant --w2 1111 --p2 stratum+tcp://pool.us.woolypooly.com:3122 --max_dual_autotune_drop 0.92 --nc 1

pause