@echo off
cd /d %~dp0

:: -- OC INTRO --
:: BzMiner supports overclocking options through the command line (per algo/per gpu). All overclock options begin with "oc_"

:: For a current list of options, run "bzminer --help"

:: Here's an example overclock for kaspa
:: bzminer -a kaspa -w kaspa:0000 -p stratum+tcp://pool.woolypooly.com:3112 --nc 1 --oc_fan_speed 100 --oc_core_clock_offset 100 --oc_lock_memory_clock 810 --oc_power_limit 200

:: -- OC PER ALGO --
:: BzMiner supports alternate/split mining, most notibly +zil. These combinations may include two algos that want opposite overclocks. In this case, bzminer supports specifying an overclock for each algo. Here's an example for kaspa + zil:

:: bzminer.exe -a kaspa -w 0000 -p stratum+tcp://pool.woolypooly.com:3112 --a2 zil --w2 1111 --p2 zmp://zil.flexpool.io --oc_fan_speed 100 --oc_core_clock_offset 100 --oc_lock_memory_clock 810 -- oc_power_limit 200 --oc_fan_speed2 100 --oc_core_clock_offset2 -100 --oc_lock_memory_clock2 0 --oc_memory_clock_offset 1000 --oc_power_limit2 200 --oc_delay_ms 50

:: notice the --oc_delay_ms. This option is used to give the oc time to kick in before starting to mine the next algo. Without a delay, the card can potentially crash if oc is too high in the wrong direction for an algo.

:: -- MULTIPLE GPUS --

:: bzminer supports setting oc's for each algo/for each gpu. This is done by providing a list of values to the oc_ options, one for each gpu in the order of the gpu Id's

:: for example, say there is a 3 gpu rig. we only want to set oc on the first and last card, but not the second card:

:: --oc_power_limit 200 0 200

:: If there are more gpu's than values, bzminer will wrap to the start of the values for the rest of the gpus, for example:

:: a 6 card rig with the below option:

:: --oc_power_limit 200 0 250

:: GPU 0 will get 200
:: GPU 1 will get 0
:: GPU 2 will get 250
:: GPU 3 will get 200 (start wrapping back to the start)
:: GPU 4 will get 0
:: GPU 5 will get 250

pause