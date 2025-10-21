@echo off
cd /d %~dp0

:: replace 0000 with your etc wallet address
:: replace kaspa:1111 with your kaspa wallet address
:: NOTE: address needs to start with "kaspa:"
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: herominers
bzminer -a etchash -w 0000 -p stratum+tcp://de.etc.herominers.com:1150 --a2 kaspa --w2 kaspa:1111 --p2 stratum+tcp://de.kaspa.herominers.com:1206 --max_dual_autotune_drop 0.92 --nc 1

:: ethermine + wooly
bzminer -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 kaspa --w2 kaspa:1111 --p2 stratum+tcp://pool.woolypooly.com:3112 --max_dual_autotune_drop 0.92 --nc 1

:: etc + kaspa (solo)
::bzminer -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 kaspa --w2 kaspa:1111 --p2 solo+tcp://127.0.0.1:16110 --max_dual_autotune_drop 0.92 --nc 1

pause