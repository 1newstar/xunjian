#!/bin/bash
. ~/.bash_profile

##local host time##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
LOCAL_TIME=`echo $I_DATE $I_TIME`


echo ''>/tmp/create_log_dir.log
if [ ! -d /tmp/xunjian/log/local ]
then
	mkdir -p /tmp/xunjian/log/local
	echo "/tmp/xunjian/log/local has been created at $LOCAL_TIME"
else
	echo "/tmp/xunjian/log/local is exist at $LOCAL_TIME"

fi
