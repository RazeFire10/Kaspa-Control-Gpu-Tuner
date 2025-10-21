@echo off
cd /d %~dp0

:: replace 0000 with your address

:: herominers
bzminer -a etchash -w 0000 -p stratum+tcp://de.etc.herominers.com:1150 --nc 1

:: mine to ethermine
::bzminer -a etchash -w 0000 -p stratum+tcp://us1-etc.ethermine.org:4444 --nc 1

:: mine to hiveon
::bzminer -a etchash -w 0000 -p stratum+tcp://na-etc.hiveon.net:8888 --nc 1

:: mine to 2miners
::bzminer -a etchash -w 0000 -p ethstratum+tcp://us-etc.2miners.com:1010 --nc 1

pause