@echo off
cd /d %~dp0

:: replace 0000 with your wallet address

:: use option `cpu_threads` - Number of cpu threads to mine on. Default is 0, use number of cores available (bz will subtract 1-4 threads to ensure system doesn't lock up or lag)
:: use option `cpu_threads_start_offset` - Offset in logical processors that the cpu threads should start at. this allows you to easily keep mining off the first x number of cores for system stability

:: - NOTE - Using all available processors will have a negative impact. If manually specifying threads, keep in mind that the os needs a processor to work on, bz itself needs a processor, gpus each need their own threads (they can share processors), and there's an additional processor pinned to 100% usage to distribute the work among the verus workers. bz will automatically reduce thread count to account for these if no thread count is specified.

:: cpu affinity: you can specify which exact logical processors you want to mine on using the option --cpu_affinity. This is a hex string where each bit represents whether a logical processor is enabled or not. This option overrides cpu_threads and cpu_threads_start_offset
::  --cpu_affinity FFFFFFFF

:: - NOTE - Lower end cpus may not be able to mine, or may have very bad hashrate

:: vipor
bzminer -a verus -r workername -w 0000 -p stratum+tcp://us.vipor.net:5040 --nc 1 --cpu 1 --cpu_threads 0 --cpu_threads_start_offset 0

pause