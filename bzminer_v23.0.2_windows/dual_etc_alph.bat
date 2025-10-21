@echo off
cd /d %~dp0

:: replace 0000 with your etc wallet address
:: replace kaspa:1111 with your alph wallet address
:: adjust --max_dual_autotune_drop to change how much eth hashrate your willing to lose when autotuning (default --i2 is 0, autotune)

:: herominers
bzminer -a etchash -w 0000 -p stratum+tcp://de.etc.herominers.com:1150 --a2 alph --w2 1111 --p2 stratum+tcp://de.alephium.herominers.com:1199 --max_dual_autotune_drop 0.92 --nc 1

:: ethermine + metapool
::bzminer -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 alph --w2 1111 --p2 stratum+tcp://eu.metapool.tech:20032 --max_dual_autotune_drop 0.92 --nc 1

:: ethermine + p1pool
::bzminer -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 alph --w2 alephiumwallet.worker --p2 stratum+tcp://alph.asia.p1pool.com:20032 --max_dual_autotune_drop 0.92 --nc 1

pause