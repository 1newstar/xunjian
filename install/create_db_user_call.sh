#!/bin/bash
. ~/.bash_profile

##local host time##
I_DATE=`date +%Y-%m-%d`
I_TIME=`date +%H:%M:%S`
LOCAL_HOST_TIME=`echo $I_DATE $I_TIME`

##script install path##
INSTALL_PATH=`crontab -l| grep cpu_call|awk -F script_call '{print $1}'|awk -F sh '{print $2}'|awk '{print $1}'`

##source datebase info##
SOURCE_DATABASE_IP=`cat ${INSTALL_PATH}database_info/source_database.sh | grep node1 | awk -F + '{print $1}' | awk -F : '{print $2}'`


echo \######################################################################
echo \"create_db_user.sh\" script run at $LOCAL_HOST_TIME      
echo source database ip address is  $SOURCE_DATABASE_IP
echo \######################################################################


for i in $SOURCE_DATABASE_IP
do
{
##get password##
PASSWORD=`cat ${INSTALL_PATH}database_info/source_database.sh | grep $i | awk -F + '{print $3}' | awk -F : '{print $2}'`

##Send create sql file to remote server##
sshpass -p $PASSWORD scp -o StrictHostKeyChecking=no ${INSTALL_PATH}install/create_db_user.sh oracle@$i:/tmp/create_db_user.sh

##call the remote server SQL script##
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no oracle@$i  'sh /tmp/create_db_user.sh'>>/tmp/xunjian/log/$i/create_db_user.log

}& 
done
wait

