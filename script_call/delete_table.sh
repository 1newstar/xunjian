#!/bin/bash
. ~/.bash_profile

CURRENT_USER=`whoami`

if [ $CURRENT_USER == oracle ]
then

##local host time##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
LOCAL_HOST_TIME=`echo $I_DATE $I_TIME`


##script install path##
INSTALL_PATH=`crontab -l| grep cpu_call|awk -F script_call '{print $1}'|awk -F sh '{print $2}'|awk '{print $1}'`

##target datebase info##
TARGET_DATABASE=`cat ${INSTALL_PATH}database_info/target_database.sh|grep database_info|awk -F : '{print "@"$2":"$3"/"$4}'`



echo \######################################################################
echo delete  process started at $LOCAL_HOST_TIME      
echo target database info is  $TARGET_DATABASE
echo \######################################################################


sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.CPU_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.CPU_USEAGE table has been deleted

sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.MEMORY_USEAGE  where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.MEMORY_USEAGE table has been deleted

sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.DISK_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.DISK_USEAGE table has been deleted

sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.ASM_DISK_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.ASM_DISK_USEAGE table has been deleted

sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.REDO_LOG_SWITCH where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.REDO_LOG_SWITCH table has been deleted


sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.TABLESPACE_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.TABLESPACE_USEAGE table has been deleted


sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.TEMP_TABLESPACE_USEAGE  where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.TEMP_TABLESPACE_USEAGE table has been deleted


sqlplus -S xunjian/oracle$TARGET_DATABASE  << EOF
delete from xunjian.UNDO_TABLESPACE_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.UNDO_TABLESPACE_USEAGE table has been deleted

else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi