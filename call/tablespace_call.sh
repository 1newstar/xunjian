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
XUNJIAN_USER=`cat /home/oracle/xunjian/db_info/xunjian_user.cnf | grep XUNJIAN_USER| awk -F = '{print $2}'|awk '{print $1}'`
XUNJIAN_PASSWORD=`cat /home/oracle/xunjian/db_info/xunjian_user.cnf | grep XUNJIAN_PASSWORD| awk -F = '{print $2}'|awk '{print $1}'`

##script install path##
INSTALL_PATH=/home/oracle/xunjian

##source datebase info##
SOURCE_DB_IP=`cat $INSTALL_PATH/db_info/source_db.cnf|grep source_db_node1|awk '{print $2}'|awk -F : '{print $2}'`


##target datebase info ##
TARGET_DB_IP=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $2}'|awk -F : '{print $2}'`
TARGET_DB_PORT=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $5}'|awk -F : '{print $2}'`
TARGET_DB_INSTANCE=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $4}'|awk -F : '{print $2}'`


echo \######################################################################
echo time:$LOCAL_TIME target database info is  @$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE
echo \######################################################################

for ip in $SOURCE_DB_IP
do
{

SOURCE_DB_HOSTNAME=`cat $INSTALL_PATH/db_info/source_db.cnf|grep $ip|awk '{print $3}'|awk -F : '{print $2}'`
SOURCE_DB_PORT=`cat $INSTALL_PATH/db_info/source_db.cnf|grep $ip|awk '{print $5}'|awk -F : '{print $2}'`
SOURCE_DB_INSTANCE=`cat $INSTALL_PATH/db_info/source_db.cnf|grep $ip|awk '{print $4}'|awk -F : '{print $2}'`


##create log directory##
if [ ! -d /tmp/xunjian/sqlfile/$SOURCE_DB_HOSTNAME ]
then
	mkdir -p /tmp/xunjian/sqlfile/$SOURCE_DB_HOSTNAME 
fi

if [ ! -d /tmp/xunjian/log/$SOURCE_DB_HOSTNAME ]
then
	mkdir -p /tmp/xunjian/log/$SOURCE_DB_HOSTNAME
fi

##Empty the temporary SQL file at start##
echo ''>/tmp/xunjian/sqlfile/$SOURCE_DB_HOSTNAME/tablespace_created_sql.sql


##connect source database and get database data##
sqlplus -S $XUNJIAN_USER/$XUNJIAN_PASSWORD@$ip:$SOURCE_DB_PORT/$SOURCE_DB_INSTANCE  @$INSTALL_PATH/script/tablespace_useage.sql >>/tmp/xunjian/sqlfile/$SOURCE_DB_HOSTNAME/tablespace_created_sql.sql


##execute sql##
sqlplus -S $XUNJIAN_USER/$XUNJIAN_PASSWORD@$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE @/tmp/xunjian/sqlfile/$SOURCE_DB_HOSTNAME/tablespace_created_sql.sql >>/tmp/xunjian/log/$SOURCE_DB_HOSTNAME/tablespace.log




echo ''
echo "sql script path is  /tmp/xunjian/sqlfile/$SOURCE_DB_HOSTNAME/tablespace_created_sql.sql"
echo "sql script execute log path is  /tmp/xunjian/log/$SOURCE_DB_HOSTNAME/tablespace.log"
echo "The SQL script on the $SOURCE_DB_HOSTNAME has been executed"
echo ''
}& 
done
wait
else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi





