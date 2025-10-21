@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: use option `cpu_threads` - Number of threads to use to compute the verus hashes. Default is 0, use number of cores available (bz will subtract 1-4 threads to ensure system doesn't lock up)
:: use option `cpu_threads_start_offset` - Offset in logical processors that the cpu threads should start at. this allows you to easily keep mining off the first x number of cores for system stability

:: use option `warthog_max_ram_gb` - Amount of RAM to use to store sha hashes while cpu threads are calculating verus hashes. Default is 0. Value of 0 will allow bz to choose (which is 2gb for 32 threads and under, otherwise 3gb). If not enough avaiable ram, will use available ram minus 1gb. if still not enough ram, will use available ram / 2.
:: use option `warthog_verus_hr_target` - Specify the amount of verus hashrate each gpu should provide to the verus workers. If all gpu's have a verus hashrate specified, calibration will be skipped. Hashrates are specified in hashes per second, and are separated by spaces. Default is 0

:: - NOTE - Warthog gpu performance will depend on many variables, such as PCI generation (1,2,3,4), PCI lanes (1x, 4x, 8x, 16x), (if on risers, higher gen speeds can cause pci errors if cables are criss-crossed with other cables due to interference, leading to possible invalid sha shares sometimes), how many gpus are currently participating, ram speeds, ram and cpu caches, cpu speeds, and even the os (windows/linux) can have an impact. Just be aware that there are many reasons why different setups may cause the same card to have drasticaly different results from other setups using that same card.
:: - NOTE - Using all available processors will have a negative impact. If manually specifying threads, keep in mind that the os needs a processor to work on, bz itself needs a processor, gpus each need their own threads (they can share processors), and there's an additional processor pinned to 100% usage to distribute the work among the verus workers. bz will automatically reduce thread count to account for these if no thread count is specified.
:: - NOTE - Status column now shows gpu hashrate/verus hashrate, where gpu hashrate is how many sha hashes the gpu is doing, and verus hashrate is how many sha hashes its currently providing the verus workers. those numbers across the gpus should add up to match the verus hr in the pool status

:: cpu affinity: you can specify which exact logical processors you want to mine on using the option --cpu_affinity. This is a hex string where each bit represents whether a logical processor is enabled or not. This option overrides cpu_threads and cpu_threads_start_offset
::  --cpu_affinity FFFFFFFF

:: - NOTE - Lower end cpus, or rigs with under 2gb may not be able to mine warthog, or may have very bad hashrate

:: --amd 1, --intel 1, --nvidia 1 enable all 3 platforms, set 0 on platforms you don't want to run on

:: cedric-crispin pool
bzminer -a warthog -r test -w 0000 -p stratum+tcp://warthog.cedric-crispin.com:4354 --nc 1 --nvidia 1 --amd 1 --cpu_threads 0 --warthog_max_ram_gb 0 --warthog_verus_hr_target 0

:: warthogunited.com pool
::bzminer -a warthog -r test -w 0000 -p stratum+tcp://warthogunited.com:2001 --nc 1 --nvidia 1 --amd 1 --cpu_threads 0 --warthog_max_ram_gb 0 --warthog_verus_hr_target 0

:: wooly pool
::bzminer -a warthog -r test -w 0000 -p stratum+tcp://pool.us.woolypooly.com:3140 --nc 1 --nvidia 1 --amd 1 --cpu_threads 0 --warthog_max_ram_gb 0 --warthog_verus_hr_target 0

:: acc pool
::bzminer -a warthog -r test -w 0000 -p stratum+tcp://us.acc-pool.pw:12000 --nc 1 --nvidia 1 --amd 1 --cpu_threads 0 --warthog_max_ram_gb 0 --warthog_verus_hr_target 0

:: solo over rpc (recommended, change 127.0.0.1 to ip node is running on, ensure to run node with `--rpc 0.0.0.0:3000`
::bzminer -a warthog -w 0000 -p http://127.0.0.1:3000 --nc 1 --amd 1 --nvidia 1 --intel 1 --cpu_threads 0 --warthog_max_ram_gb 0

:: solo, change 127.0.0.1 to ip node is running on, ensure to run node with `--stratum 0.0.0.0:3456`
::bzminer -a warthog -w 0000 -p stratum+tcp://127.0.0.1:3456 --nc 1 --amd 1 --nvidia 1 --intel 1 --cpu_threads 0 --warthog_max_ram_gb 0


pause