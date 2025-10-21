@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

::-- dynex_pow_ratio -------------------------------------------------------------
::Bz allows you to dedicate individual cards to either POW or POUW on Dynex using this option.

::- This is an array of values, one for each gpu
::- In config.txt (hiveos), an example for 3 gpus would be "dynex_pow_ratio": [1.0, 1.0, 1.0]
::- In command line, and example for 3 gpus would be --dynex_pow_ratio 1.0 1.0 1.0

::- A value of 0.0 will mine ONLY POUW
::- A value of 1.0 (Default) will mine both POUW and POW. It will choose a POW ratio that matches POUW
::- A value of 2.0 will fully mine only POW. Any value higher than 1.0 will not mine POUW
::- A value between 0.0 and 1.0 will determine how much POW is mined, values closer to 1.0 will mine POW more intensely, while values closer to 0.0 will mine POW less intensely
::- A value between 1.0 and 2.0 will determine how intensely to mine ONLY POW

::- A statistic in the status column of the tables called "pow slip" will show you how much POW hashrate above or below the POUW hashrate you are doing. If below (-), you should increase your pow hashrate. If above, you are wasting resources doing unecessary POW hashrate and you should lower your POW hashrate. NOTE: It is not possible to be rewarded for POW hashrate above your POUW hashrate!
:: --------------------------------------------------------------------------------

:: mine to minenow
bzminer -a dynex -w 0000 -p us-east.dnx.minenow.space:18000 --nc 1 --pool_password workername --dynex_pow_ratio 1.0

:: mine to herominers
::bzminer -a dynex -w 0000 -p us.dynex.herominers.com:1120 --nc 1 --pool_password workername --dynex_pow_ratio 1.0

:: mine to ekapool
::bzminer -a dynex -w 0000 -p dnx.ca.ekapool.com:19666 --nc 1 --pool_password workername --dynex_pow_ratio 1.0

:: mine to deepminerz
::bzminer -a dynex -w 0000 -p pool.us.deepminerz.com:3333 --nc 1 --pool_password workername --dynex_pow_ratio 1.0

:: mine to neuropool
::bzminer -a dynex -w 0000 -p dnx.us.neuropool.net:19332 --nc 1 --pool_password workername --dynex_pow_ratio 1.0

pause