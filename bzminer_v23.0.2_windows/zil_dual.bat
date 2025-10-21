@echo off
cd /d %~dp0

:: zil can be mined by itself, in which case the gpu will sit idle while it waits for the zil window
:: zil can be mined with any other algo. When the zil window starts, all algos (except zil) pause until the zil window finishes, see dual_zil.bat
:: zil can also be mined with a dual combo (tri mining), eg. zil + {eth + kas}, see zil_tri.bat

:: overclocks can be changed between mining zil and mining the main algos. See overclocking.bat

:: replace 0000 with your main coin wallet
:: replace 1111 with your zil coin wallet

:: dynex + zil (crazypool)
bzminer.exe -a dynex -w 0000 -p us-east.dnx.minenow.space:18000 --a2 zil --w2 1111 --p2 ethproxy+tcp://eu.crazypool.org:5005

:: nexa + zil (crazypool)
::bzminer.exe -a nexa -w 0000 -p stratum+tcp://pool.ca.woolypooly.com:3124 --a2 zil --w2 1111 --p2 ethproxy+tcp://eu.crazypool.org:5005

:: kas + zil (flexpool)
::bzminer.exe -a kaspa -w 0000 -p stratum+tcp://pool.woolypooly.com:3112 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: nexa + zil (gteh)
::bzminer.exe -a nexa -w 0000 -p stratum+tcp://pool.ca.woolypooly.com:3124 --a2 zil --w2 1111 --p2 ethstratum+ssl://eu.gteh.org:9009

:: radiant + zil (flexpool)
::bzminer.exe -a radiant -w 0000 -p stratum+tcp://pool.us.woolypooly.com:3122 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: kas + zil (shardpool)
::bzminer.exe -a kaspa -w 0000 -p stratum+tcp://pool.woolypooly.com:3112 --a2 zil --w2 1111 --p2 zmp+tcp://eu1-zil.shardpool.io:3333

:: kas + zil (ezil, etc is ignored so using fake etc address. ezil won't accept null address so using dummy address)
::bzminer.exe -a kaspa -w 0000 -p stratum+tcp://pool.woolypooly.com:3112 --a2 zil --w2 0x1234567890123456789012345678901234567890.1111.workername --p2 ethstratum+ssl://us-east.ezil.me:24443 --cache_dag 1

:: kas + zil (rustpool, etc is ignored so using null etc address)
::bzminer.exe -a kaspa -w 0000 -p stratum+tcp://pool.woolypooly.com:3112 --a2 zil --w2 0x0000000000000000000000000000000000000000.workername --pool_password2 1111@eth-se.flexpool.io:4444@4G --p2 ethproxy+tcp://eu3-zil.rustpool.xyz:8008 --cache_dag 1

:: kas + zil (k1pool, replace 1111 with your k1pool address)
::bzminer.exe -a kaspa -w 0000 -p stratum+tcp://us.kaspa.k1pool.com:3112 --a2 zil --w2 1111 --p2 ethstratum+tcp://us.ethash.k1pool.com:5000 --cache_dag 1

:: ethw + zil
::bzminer.exe -a ethw -w 0000 -p ethproxy+tcp://pool.woolypooly.com:3096 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: etc + zil
::bzminer.exe -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: etc + zil (ezil)
::bzminer.exe -a ethash -w 0000.1111.workername -p ethproxy+tcp://us-east.ezil.me:5555 --cache_dag 1 --nc 1

:: etc + zil (rustpool)
::bzminer.exe -a ethash -w 0000.workername -p ethproxy+tcp://eu3-zil.rustpool.xyz:8008 --pool_password 1111@eth-se.flexpool.io:4444@4G --cache_dag 1 --nc 1

:: erg + zil
::bzminer.exe -a ergo -w 0000 -p stratum-ergo.flypool.org:3333 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: rvn + zil
::bzminer.exe -a kawpow -w 0000 -p stratum+ssl://stratum-ravencoin.flypool.org:3443 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: alph + zil
::bzminer.exe -a ethash -w 0000 -p ethstratum+tcp://eth.geodns.flexpool.io:4444 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io

:: ol + zil
::bzminer.exe -a ol -w 0000 -p ethproxy+ssl://us.extremehash.net:3443 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io
pause