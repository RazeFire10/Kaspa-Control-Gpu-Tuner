@echo off
cd /d %~dp0

:: zil can be mined with any other algo. When the zil window starts, all algos (except zil) pause until the zil window finishes
:: zil can also be mined with a dual combo, eg. zil + {eth + kas}
:: note its important that the dual algos are the first two algos specified when tri mining

:: overclocks can be changed between mining zil and mining the main algos. See overclocking.bat

:: replace 0000 with your main coin wallet
:: replace 1111 with your second coin wallet
:: replace 2222 with your zil coin wallet

:: zil + etc + ironfish
bzminer.exe -a etchash -w 0000 -p ethstratum+tcp://etc-us-east.flexpool.io:4444 --a2 ironfish --w2 1111 -p stratum+tcp://iron.fpmp.net:8888 --a3 zil --w3 2222 --p3 zmp://zil.flexpool.io

:: zil + octa + radiant
::bzminer.exe -a octa -w 0000 -p ethproxy+ssl://us.vipor.net:5104 --a2 radiant --w2 1111 -p stratum+tcp://pool.us.woolypooly.com:3122 --a3 zil --w3 2222 --p3 zmp://zil.flexpool.io

:: zil + etc + kas
::bzminer.exe -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --a2 kaspa --w2 1111 --p2 stratum+tcp://pool.woolypooly.com:3112 --a3 zil --w3 2222 --p3 zmp://zil.flexpool.io

:: zil + erg + kas
::bzminer.exe -a ergo -w 0000 -p stratum-ergo.flypool.org:3333 --a2 kaspa --w2 1111 --p2 stratum+tcp://pool.woolypooly.com:3112 --a3 zil --w3 2222 --p3 zmp://zil.flexpool.io


pause