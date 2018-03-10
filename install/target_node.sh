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


##target datebase info ##
TARGET_DB_IP=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $2}'|awk -F : '{print $2}'`
TARGET_DB_PORT=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $5}'|awk -F : '{print $2}'`
TARGET_DB_INSTANCE=`cat $INSTALL_PATH/db_info/target_db.cnf|grep target_db_info|awk '{print $4}'|awk -F : '{print $2}'`


echo \######################################################################
echo target database info is  @$TARGET_DB_IP:$TARGET_DB_PORT/$TARGET_DB_INSTANCE
echo \######################################################################

for ip in $TARGET_DB_IP
do
{



##get password##
PASSWORD=`cat ${INSTALL_PATH}/db_info/source_db.cnf | grep $ip | awk '{print $7}' | awk -F : '{print $2}'|awk '{print $1}'`

##Send create sql file to remote server##
sshpass -p $PASSWORD scp -o StrictHostKeyChecking=no ${INSTALL_PATH}/install/create_user_script/create_user_and_table.sh oracle@$ip:/tmp/create_user_and_table.sh

##call the remote server SQL script##
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no oracle@$ip  'sh /tmp/create_user_and_table.sh'

}& 
done
wait

else
	echo "current user is "\"$CURRENT_USER\"", please  execute this file with Oracle;"
fi