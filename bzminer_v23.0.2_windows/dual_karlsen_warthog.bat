@echo off
cd /d %~dp0

:: replace karlsen:0000 with your wallet address
:: NOTE: karlsen address needs to start with "karlsen:"

:: replace 1111 with your warthog wallet address

:: use option `cpu_threads` - Number of threads to use to compute the verus hashes. Default is 0, use number of cores available (bz will subtract 1-4 threads to ensure system doesn't lock up)
:: use option `cpu_threads_start_offset` - Offset in logical processors that the cpu threads should start at. this allows you to easily keep mining off the first x number of cores for system stability

:: use option `warthog_max_ram_gb` - Amount of RAM to use to store sha hashes while cpu threads are calculating verus hashes. Default is 0. Value of 0 will allow bz to choose (which is 2gb for 32 threads and under, otherwise 3gb). If not enough avaiable ram, will use available ram minus 1gb. if still not enough ram, will use available ram / 2.
:: use option `warthog_verus_hr_target` - Specify the amount of verus hashrate each gpu should provide to the verus workers. If all gpu's have a verus hashrate specified, calibration will be skipped. Hashrates are specified in hashes per second, and are separated by spaces. Default is 0

:: use option `warthog_cpu_threads` - Number of threads to use to compute the verus hashes. Default is 0, use number of cores available (bz will subtract 1-4 threads to ensure system doesn't lock up)
:: use option `warthog_max_ram_gb` - Amount of RAM to use to store sha hashes while cpu threads are calculating verus hashes. Default is 0. Value of 0 will allow bz to choose (which is 2gb for 32 threads and under, otherwise 3gb). If not enough avaiable ram, will use available ram minus 1gb. if still not enough ram, will use available ram / 2.
:: use option `warthog_verus_hr_target` - Specify the amount of verus hashrate each gpu should provide to the verus workers. If all gpu's have a verus hashrate specified, calibration will be skipped. Hashrates are specified in hashes per second, and are separated by spaces. Default is 0

:: - NOTE - Warthog gpu performance will depend on many variables, such as PCI generation (1,2,3,4), PCI lanes (1x, 4x, 8x, 16x), (if on risers, higher gen speeds can cause pci errors if cables are criss-crossed with other cables due to interference, leading to possible invalid sha shares sometimes), how many gpus are currently participating, ram speeds, ram and cpu caches, cpu speeds, and even the os (windows/linux) can have an impact. Just be aware that there are many reasons why different setups may cause the same card to have drasticaly different results from other setups using that same card.
:: - NOTE - Using all available processors will have a negative impact. If manually specifying threads, keep in mind that the os needs a processor to work on, bz itself needs a processor, gpus each need their own threads (they can share processors), and there's an additional processor pinned to 100% usage to distribute the work among the verus workers. bz will automatically reduce thread count to account for these if no thread count is specified.
:: - NOTE - Status column now shows gpu hashrate/verus hashrate, where gpu hashrate is how many sha hashes the gpu is doing, and verus hashrate is how many sha hashes its currently providing the verus workers. those numbers across the gpus should add up to match the verus hr in the pool status

:: cpu affinity: you can specify which exact logical processors you want to mine on using the option --cpu_affinity. This is a hex string where each bit represents whether a logical processor is enabled or not. This option overrides cpu_threads and cpu_threads_start_offset
::  --cpu_affinity FFFFFFFF

:: - NOTE - Lower end cpus, or rigs with under 2gb may not be able to mine warthog, or may have very bad hashrate

:: use --i2 to adjust the ratio of wart sha hashes per karlsen hashes. the higher means more sha hashes, which can reduce karlsen hashes. 0 is auto tune, and will attempt to find the highest number of both karlsen and wart hashes, which can drastically reduce karlsen hashes. the more gpus dual mining, the less sha hashes you may need to do on each hashrate to keep the cpu verus hashrate full for warthog

bzminer -a karlsen -w karlsen:0000 -p stratum+tcp://us.karlsen.herominers.com:1195 --a2 warthog --w2 1111 --p2 stratum+tcp://pool.us.woolypooly.com:3140 --i2 0 --nc 1 --cpu_threads 0 --cpu_threads_start_offset 0 --warthog_max_ram_gb 0 --warthog_verus_hr_target 0


pause