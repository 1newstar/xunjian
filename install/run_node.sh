#!/bin/bash
. ~/.bash_profile

CURRENT_USER=`whoami`

if [ $CURRENT_USER == oracle ]
then

cd ..
PRECENT_DIRECTORY=`pwd`
SCRIPT_DIRECTORY=$PRECENT_DIRECTORY/script_call

##create log directory##
if [ ! -d /tmp/xunjian/log/local ]
then
mkdir -p /tmp/xunjian/log/local
fi

LOG_DIRECTORY=/tmp/xunjian/log/local

(crontab -l; echo "#######################################xunjian_call######################################################################" ) | crontab

(crontab -l; echo "*/1 * * * *   sh $SCRIPT_DIRECTORY/test_log_directory.sh  >> $LOG_DIRECTORY/test_log_directory.log 2>&1") | crontab

(crontab -l; echo "*/2 * * * *   sh $SCRIPT_DIRECTORY/cpu_call.sh  >> $LOG_DIRECTORY/cpu_xunjian.log 2>&1") | crontab

(crontab -l; echo "*/2 * * * *   sh $SCRIPT_DIRECTORY/memo_call.sh >> $LOG_DIRECTORY/memo_xunjian.log 2>&1") | crontab

(crontab -l; echo "*/30 * * * *  sh $SCRIPT_DIRECTORY/temp_call.sh >> $LOG_DIRECTORY/temp_xunjian.log 2>&1") | crontab

(crontab -l; echo "*/30 * * * *  sh $SCRIPT_DIRECTORY/undo_call.sh >> $LOG_DIRECTORY/undo_xunjian.log 2>&1") | crontab

(crontab -l; echo "*/30 * * * *  sh $SCRIPT_DIRECTORY/disk_call.sh >> $LOG_DIRECTORY/disk_xunjian.log 2>&1") | crontab

(crontab -l; echo "*/30 * * * *  sh $SCRIPT_DIRECTORY/asmdisk_call.sh >> $LOG_DIRECTORY/asmdisk_xunjian.log 2>&1") | crontab

(crontab -l; echo "*/30 * * * *  sh $SCRIPT_DIRECTORY/tablespace_call.sh >> $LOG_DIRECTORY/tablespace_xunjian.log 2>&1") | crontab

(crontab -l; echo "10 * * * *    sh $SCRIPT_DIRECTORY/redo_call.sh >> $LOG_DIRECTORY/redo_xunjian.log 2>&1") | crontab

(crontab -l; echo "59 23 */1 * * sh $SCRIPT_DIRECTORY/pack_log.sh >> $LOG_DIRECTORY/pack_log_xunjian.log 2>&1") | crontab

(crontab -l; echo "5 0 */1 * *   sh $SCRIPT_DIRECTORY/delete_table.sh >> $LOG_DIRECTORY/delete_xunjian.log 2>&1") | crontab

(crontab -l; echo "#######################################xunjian_call######################################################################" ) | crontab


echo The scheduled task \"xunjian\"  has been added

else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi
