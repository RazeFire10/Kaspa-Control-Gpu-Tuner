@echo off
cd /d %~dp0

:: replace 0000 with your ergo wallet address
:: replace kaspa:1111 with your kaspa wallet address
:: NOTE: address needs to start with "kaspa:"
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: ergo + kaspa (herominers)
bzminer -a ergo -w 0000 -p de.ergo.herominers.com:1180 --a2 kaspa --w2 kaspa:1111 --p2 stratum+tcp://de.kaspa.herominers.com:1206 --max_dual_autotune_drop 0.92 --nc 1

:: ergo + kaspa (wooly)
::bzminer -a ergo -w 0000 -p stratum-ergo.flypool.org:3333 --a2 kaspa --w2 kaspa:1111 --p2 stratum+tcp://pool.woolypooly.com:3112 --max_dual_autotune_drop 0.92 --nc 1

:: ergo + kaspa (solo)
::bzminer -a ergo -w 0000 -p stratum-ergo.flypool.org:3333 --a2 kaspa --w2 kaspa:1111 --p2 solo+tcp://127.0.0.1:16110 --max_dual_autotune_drop 0.92 --nc 1

pause