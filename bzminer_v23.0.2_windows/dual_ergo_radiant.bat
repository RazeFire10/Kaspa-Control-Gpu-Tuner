@echo off
cd /d %~dp0

:: replace 0000 with your ergo wallet address
:: replace 1111 with your radiant wallet address
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: ergo + radiant

:: herominers + wooly
bzminer -a ergo -w 0000 -p de.ergo.herominers.com:1180 --a2 radiant --w2 1111 --p2 stratum+tcp://pool.us.woolypooly.com:3122 --max_dual_autotune_drop 0.92 --nc 1

:: ethermine + wooly
::bzminer -a ergo -w 0000 -p stratum-ergo.flypool.org:3333 --a2 radiant --w2 1111 --p2 stratum+tcp://pool.us.woolypooly.com:3122 --max_dual_autotune_drop 0.92 --nc 1

pause