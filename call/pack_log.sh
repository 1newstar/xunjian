#!/bin/bash
. ~/.bash_profile


CURRENT_USER=`whoami`

if [ $CURRENT_USER == oracle ]
then

##local host time##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
LOCAL_HOST_TIME=`echo $I_DATE $I_TIME`

##time director##
I_MON=`date +%Y-%m`
I_DATE=`date +%Y-%m-%d`

##Package log folder##

echo 'Ready to copy log file'

cd /tmp/xunjian/
tar jcvf $I_DATE.tar ./log
echo '-------------------------------------'

##Empty log folder##
if [ -d /tmp/xunjian/log ]
then
	cd /tmp/xunjian/log
	rm -fr ./*
	mkdir -p /tmp/xunjian/log/local
else
	mkdir -p /tmp/xunjian/log
	cd /tmp/xunjian/log
	rm -fr ./*
	mkdir -p /tmp/xunjian/log/local
fi


##create history log directory##
if [ ! -d /tmp/xunjian/hist_log/$I_MON ]
then
mkdir -p /tmp/xunjian/hist_log/$I_MON
fi


##move log file
cd /tmp/xunjian/
mv $I_DATE.tar /tmp/xunjian/hist_log/$I_MON

else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi