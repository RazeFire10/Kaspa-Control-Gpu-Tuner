@echo off
cd /d %~dp0

:: if pool requires all 4 mining addresses, replace each of the 4 0000 with your own mining addresses. The order may matter.

bzminer -a alph -w alph:0000 -p stratum+tcp://de.alephium.herominers.com:1199 --nc 1

:: mine to enigmapool
bzminer -a alph -w 0000 -p stratum+tcp://na-west.stratum.enigmapool.com:5002 --nc 1

:: mine to p1pool.com
bzminer -a alph -w alephiumwallet.worker -p stratum+tcp://alph.asia.p1pool.com:20032 --nc 1

:: mine to metapool.tech
::bzminer -a alph -w 0000 -p stratum+tcp://eu.metapool.tech:20032 --nc 1

:: mine to woolypooly.com
::bzminer -a alph -w 0000 -p stratum+tcp://pool.us.woolypooly.com:3106 --nc 1

:: mine to alephium-pool.com
::bzminer -a alph -w 0000 -p stratum+tcp://pool.alephium-pool.com:20032 --nc 1

:: mine to devgent. replace the port with the port associated with your login
::bzminer -a alph -w 0000 -p alphstratum+tcp://185.71.66.100:10159 --nc 1

:: solo mine. may not require an address. in that case leave the dummy addresses
::bzminer -a alph -w 0000 -p alphstratum+tcp://127.0.0.1:10973 --nc 1

pause