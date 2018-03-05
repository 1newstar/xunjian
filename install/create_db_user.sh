#!/bin/bash
. ~/.bash_profile

USERNAME=xunjian
PASS=oracle

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
create user $USERNAME identified by $PASS;
grant connect to xunjian;
grant select on v_\$instance to xunjian;
grant select on v_\$database to xunjian;
grant select on v_\$log_history to xunjian;
grant select on dba_data_files to xunjian;
grant select on dba_free_space to xunjian;
grant select on dba_undo_extents to xunjian;
grant select on dba_temp_files to xunjian;
grant select on gv_\$sort_segment to xunjian;
grant select on gv_\$archived_log to xunjian;
grant select on gv_\$asm_diskgroup to xunjian;
grant select on gv_\$instance to xunjian;
grant select on gv_\$parameter to xunjian;
EOF

fi