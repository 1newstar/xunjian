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

## disk_useage ##
DISKUSED_MAX_VALUE=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot|grep ^/dev|grep -v denied| wc -l`


echo "select 'The SQL script execution start at' ||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss') from dual;"
##create sql file##
for ((i=1;i<=$DISKUSED_MAX_VALUE;i++))
do
DISK_NAME=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot |grep ^/dev | sed -n ${i}p|awk '{print $1}'`
TOTAL_SIZE=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot|grep ^/dev | sed -n ${i}p|awk '{print $2}'`
USED_SIZE=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot |grep ^/dev | sed -n ${i}p|awk '{print $3}'`
FREE_SIZE=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot |grep ^/dev | sed -n ${i}p|awk '{print $4}'`
USED_PERCENT=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot|grep ^/dev | sed 's/%//g' | sed -n ${i}p|awk '{print $5}'`
MOUNTED_ON=`df -mPx fuse.gvfs-fuse-daemon|grep -v tmpfs|grep -v /boot |grep ^/dev | sed -n ${i}p|awk '{print $6}'`

if [ $USED_PERCENT -gt 80 ];then
echo "insert into xunjian.DISK_USEAGE(INSERT_DATE,HOSTNAME,DISK_NAME,TOTAL_SIZE,USED_SIZE,FREE_SIZE,USED_PERCENT,MOUNTED_ON)values(to_date('$INSERT_DATE','yyyy-mm-dd hh24:mi:ss'),'$HOSTNAME','$DISK_NAME',$TOTAL_SIZE,$USED_SIZE,$FREE_SIZE,$USED_PERCENT,'$MOUNTED_ON');"
fi
done

echo "select 'The SQL script DISK_USEAGE on the $HOSTNAME has been executed' from dual;" 
echo "select '-----------------------------------------------------------'from dual;"
echo exit 


