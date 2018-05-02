#!/bin/bash
. ~/.bash_profile

##xunjian user##
XUNJIAN_USER=xunjian
XUNJIAN_PASSWORD=xunjian#2018


USER=`sqlplus -S / as sysdba << EOF
set heading off trimspool on feedback off
select trim(username) from dba_users where username='XUNJIAN'; 
EOF`
user=$(echo $USER)


if [ "$user"x == "XUNJIAN"x ];then 
	echo ''
	echo user:\"$user\" on $HOSTNAME is valuable,don\'t need to create it again;
	echo ''
else

sqlplus -S / as sysdba << EOF
create user $XUNJIAN_USER identified by $XUNJIAN_PASSWORD;
grant connect to $XUNJIAN_USER;
grant select on v_\$instance to $XUNJIAN_USER;
grant select on v_\$database to $XUNJIAN_USER;
grant select on v_\$log_history to $XUNJIAN_USER;
grant select on dba_data_files to $XUNJIAN_USER;
grant select on dba_free_space to $XUNJIAN_USER;
grant select on dba_undo_extents to $XUNJIAN_USER;
grant select on dba_temp_files to $XUNJIAN_USER;
grant select on gv_\$sort_segment to $XUNJIAN_USER;
grant select on gv_\$archived_log to $XUNJIAN_USER;
grant select on gv_\$asm_diskgroup to $XUNJIAN_USER;
grant select on gv_\$instance to $XUNJIAN_USER;
grant select on gv_\$parameter to $XUNJIAN_USER;
EOF

fi