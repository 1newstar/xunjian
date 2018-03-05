#!/bin/bash
. ~/.bash_profile



##sql environment variable##
echo set linesize 8000 
echo set pagesize 0 
echo set long 2000000000 
echo set longchunksize 9000000 
echo set heading off 

##CPU USEDAGE variable##
CPU_USEAGE=`mpstat 1 3|grep Average: |awk '{print $3,$5,$6}'`
USER_PERCENT=`echo $CPU_USEAGE|awk '{print $1}'`
SYSTEM_PERCENT=`echo $CPU_USEAGE|awk '{print $2}'`
IO_WAIT_PERCENT=`echo $CPU_USEAGE|awk '{print $3}'`
IDLE_PERCENT=$(echo "100-$USER_PERCENT-$SYSTEM_PERCENT-$IO_WAIT_PERCENT"|bc)

## CPU LOAD variable##
LOAD1=`uptime  | sed -n 1p | awk -F average:  '{print $2}'|sed 's/,//g'|awk '{print $1}'`
LOAD5=`uptime  | sed -n 1p | awk -F average:  '{print $2}'|sed 's/,//g'|awk '{print $2}'`
LOAD15=`uptime  | sed -n 1p | awk -F average:  '{print $2}'|sed 's/,//g'|awk '{print $3}'`

##time variable##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
INSERT_DATE=`echo $I_DATE $I_TIME`

##create sql file##
echo "select \'The SQL script execution start at\' ||to_char(sysdate,\'yyyy-mm-dd hh24:mi:ss\') from dual;"
echo "insert into xunjian.CPU_USEAGE(INSERT_DATE,HOSTNAME,USER_PERCENT,SYSTEM_PERCENT,IO_WAIT_PERCENT,IDLE_PERCENT,LOAD1,LOAD5,LOAD15)
values(to_date('$INSERT_DATE','yyyy-mm-dd hh24:mi:ss'),'$HOSTNAME',$USER_PERCENT,$SYSTEM_PERCENT,$IO_WAIT_PERCENT,$IDLE_PERCENT,$LOAD1,$LOAD5,$LOAD15);"
echo "select 'The SQL script CPU_USEAGE on the $HOSTNAME has been executed' from dual;"
echo "select '-----------------------------------------------------------'from dual;"
echo exit 
