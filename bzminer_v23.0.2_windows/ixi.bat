@echo off
cd /d %~dp0

:: replace 0000 with your address

:: mine to hardbios.com
bzminer -a ixi -r rig_name -w 0000 -p http://ixian.hardbios.com:8081 --nc 1

:: mine to changeling.biz
::bzminer -a ixi -r rig_name -w 0000 -p http://ixian.changeling.biz:8081 --nc 1

:: mine to mineixi.com
::bzminer -a ixi -r rig_name -w 0000 -p http://mineixi.com:80 --nc 1


pause