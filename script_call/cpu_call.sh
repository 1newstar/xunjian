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
TARGET_DATABASE=`cat ${INSTALL_PATH}database_info/target_database.sh|grep target_db_info|awk -F : '{print "@"$2":"$3"/"$4}'`

##source datebase info##
SOURCE_DATABASE_IP=`cat ${INSTALL_PATH}database_info/source_database.sh | grep node | awk -F + '{print $1}' | awk -F : '{print $2}'`

echo \######################################################################
echo \"cpu_useage\" process started at $LOCAL_HOST_TIME      
echo target database info is  $TARGET_DATABASE
echo \######################################################################

for i in $SOURCE_DATABASE_IP
do
{
##create log directory##
if [ ! -d /tmp/xunjian/sqlfile/$i ]
then
	mkdir -p /tmp/xunjian/sqlfile/$i 
fi

if [ ! -d /tmp/xunjian/log/$i ]
then
	mkdir -p /tmp/xunjian/log/$i
fi


##Empty the temporary SQL file at start##
echo ''>/tmp/xunjian/sqlfile/$i/cpu_created_sql.sql

##get password##
PASSWORD=`cat ${INSTALL_PATH}database_info/source_database.sh | grep $i | awk -F + '{print $3}' | awk -F : '{print $2}'|awk '{print $1}'`

##Send create sql file to remote server##
sshpass -p $PASSWORD scp -o StrictHostKeyChecking=no ${INSTALL_PATH}script/cpu_useage.sh oracle@$i:/tmp/cpu_useage.sh

##call the remote server SQL script##
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no $i  'sh /tmp/cpu_useage.sh'>>/tmp/xunjian/sqlfile/$i/cpu_created_sql.sql

##execute sql##
sqlplus -S xunjian/oracle$TARGET_DATABASE @/tmp/xunjian/sqlfile/$i/cpu_created_sql.sql >>/tmp/xunjian/log/$i/cpu.log

echo ''
echo "The SQL script path is  /tmp/xunjian/sqlfile/"$i"/cpu_created_sql.sql"
echo "The SQL execute log path is  /tmp/xunjian/log/"$i"/cpu.log"
echo "The SQL script on the $i has been executed"
echo ''
}& 
done
wait

else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi



