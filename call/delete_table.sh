#!/bin/bash
. ~/.bash_profile

CURRENT_USER=`whoami`

if [ $CURRENT_USER == oracle ]
then

##local host time##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
LOCAL_TIME=`echo $I_DATE $I_TIME`

##xunjian user##
XUNJIAN_USER=xunjian
XUNJIAN_PASSWORD=oracle

##script install path##
INSTALL_PATH=/home/oracle/xunjian

##source datebase info##
SOURCE_DB_IP=`cat $INSTALL_PATH/db_info/source_db.cnf|grep source_db_node1|awk '{print $2}'|awk -F : '{print $2}'`


##target datebase info ##
TARGET_DB_IP=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $2}'|awk -F : '{print $2}'`
TARGET_DB_PORT=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $5}'|awk -F : '{print $2}'`
TARGET_DB_INSTANCE=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $4}'|awk -F : '{print $2}'`


echo \######################################################################
echo delete  process started at $LOCAL_HOST_TIME      
echo target database info is  @$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE
echo \######################################################################

sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.CPU_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.CPU_USEAGE table has been deleted

sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.MEMORY_USEAGE  where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.MEMORY_USEAGE table has been deleted

sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.DISK_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.DISK_USEAGE table has been deleted

sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.ASM_DISK_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.ASM_DISK_USEAGE table has been deleted

sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.REDO_LOG_SWITCH where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.REDO_LOG_SWITCH table has been deleted


sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.TABLESPACE_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.TABLESPACE_USEAGE table has been deleted


sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.TEMP_TABLESPACE_USEAGE  where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.TEMP_TABLESPACE_USEAGE table has been deleted


sqlplus -S xunjian/oracle@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE  << EOF
delete from xunjian.UNDO_TABLESPACE_USEAGE where insert_date < sysdate-90;
EOF
echo The record of more than 90 days in the xunjian.UNDO_TABLESPACE_USEAGE table has been deleted

else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi
