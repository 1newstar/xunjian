#!/bin/bash
. ~/.bash_profile

##sql environment variable##
echo set linesize 8000 
echo set pagesize 0 
echo set long 2000000000 
echo set longchunksize 9000000 
echo set heading off 

##time variable##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
INSERT_DATE=`echo $I_DATE $I_TIME`

## memory useage ##
MemTotal=`cat /proc/meminfo| grep ^MemTotal|awk '{print $2}'`
MEMO_TOTAL=$[$MemTotal/1024]

MemFree=`cat /proc/meminfo| grep ^MemFree|awk '{print $2}'`
FREE=$[$MemFree/1024]

Buffers=`cat /proc/meminfo| grep ^Buffers|awk '{print $2}'`
BUFFERS=$[$Buffers/1024]

Cached=`cat /proc/meminfo| grep ^Cached|awk '{print $2}'`
CACHED=$[$Cached/1024]

MEMO_FREE=`expr $FREE + $BUFFERS + $CACHED`
MEMO_USED=`expr $MEMO_TOTAL - $MEMO_FREE`
MEMO_USED_PERCENT=`awk -v x=$MEMO_USED -v y=$MEMO_TOTAL 'BEGIN{printf "%.2f",x * 100/y}'`


## swap useage ##
SwapTotal=`cat /proc/meminfo| grep ^SwapTotal|awk '{print $2}'`
SWAP_TOTAL=$[$SwapTotal/1024]

SwapFree=`cat /proc/meminfo| grep ^SwapFree|awk '{print $2}'`
SWAP_FREE=$[$SwapFree/1024] 

SWAP_USED=$[$SWAP_TOTAL-$SWAP_FREE]
SWAP_USED_PERCENT=`awk -v x=$SWAP_USED -v y=$SWAP_TOTAL 'BEGIN{printf "%.2f",x * 100/y}'`


##create sql file##
echo "select 'The SQL script execution start at' ||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual;"

echo "insert into xunjian.MEMORY_USEAGE(HOSTNAME,MEMO_TOTAL,BUFFERS,CACHED,MEMO_FREE,MEMO_USED_PERCENT,SWAP_TOTAL,SWAP_USED,SWAP_FREE,SWAP_USED_PERCENT)
values('$HOSTNAME',$MEMO_TOTAL,$BUFFERS,$CACHED,$MEMO_FREE,$MEMO_USED_PERCENT,$SWAP_TOTAL,$SWAP_USED,$SWAP_FREE,$SWAP_USED_PERCENT);"

echo "select 'The SQL script MEMORY_USEAGE on the $HOSTNAME has been executed' from dual;" 
echo "select '-----------------------------------------------------------'from dual;"
echo exit


