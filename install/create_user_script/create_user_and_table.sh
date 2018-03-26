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

DATAFILE=`sqlplus -S / as sysdba << EOF
set heading off trimspool on feedback off
select file_name from dba_data_files where rownum = 1; 
EOF`
datafile_path=`echo ${DATAFILE%/*}`

if [ "$user"x == "XUNJIAN"x ];then 
	echo ''
	echo user:$user is valuable on $HOSTNAME don\'t need to create it again;
	echo ''
else

sqlplus -S / as sysdba << EOF
create  tablespace $XUNJIAN_USER datafile '$datafile_path/${XUNJIAN_USER}01.dbf' size 5G AUTOEXTEND ON NEXT 200M MAXSIZE 31G;
create user $XUNJIAN_USER identified by $XUNJIAN_PASSWORD default tablespace $XUNJIAN_USER;
grant connect,resource to $XUNJIAN_USER;
grant create any index to $XUNJIAN_USER;
grant drop any index to $XUNJIAN_USER;
grant select on dba_data_files to $XUNJIAN_USER;
grant select on dba_free_space to $XUNJIAN_USER;
grant select on dba_undo_extents to $XUNJIAN_USER;
grant select on dba_temp_files to $XUNJIAN_USER;
grant select on v_\$instance to $XUNJIAN_USER;
grant select on v_\$database to $XUNJIAN_USER;
grant select on v_\$log_history to $XUNJIAN_USER;
grant select on gv_\$sort_segment to $XUNJIAN_USER;
grant select on gv_\$archived_log to $XUNJIAN_USER;
grant select on gv_\$asm_diskgroup to $XUNJIAN_USER;
grant select on gv_\$instance to $XUNJIAN_USER;
grant select on gv_\$parameter to $XUNJIAN_USER;
-------------------------------------------------------------------------------
create table $XUNJIAN_USER.cpu_useage (
insert_date date  default sysdate,
hostname varchar2(50) not null,
user_percent number ,
system_percent number ,
io_wait_percent number ,
load1 number
);
create index i_cpu_date on $XUNJIAN_USER.cpu_useage (insert_date desc);
create index i_cpu_host on $XUNJIAN_USER.cpu_useage (hostname);

------------------------------------------------------------------------------
create table $XUNJIAN_USER.memory_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
memo_total number,
buffers number,
cached number,
free   number,
memo_used_percent number,
swap_total number,
swap_used number,
swap_free number,
swap_used_percent number
);
create index i_memo_date on $XUNJIAN_USER.memory_useage (insert_date desc);
create index i_memo_host on $XUNJIAN_USER.memory_useage (hostname);


----------------------------------------------------------------------------------
create table $XUNJIAN_USER.asm_disk_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
disk_name varchar2(50) not null,
total_size number,
used_size number,
free_size number,
used_percent number
);
create index i_asmdisk_date on $XUNJIAN_USER.asm_disk_useage (insert_date desc);
create index i_asmdisk_host on $XUNJIAN_USER.asm_disk_useage (hostname);

------------------------------------------------------------------------------------
create table $XUNJIAN_USER.redo_log_switch (
insert_date date default sysdate,
hostname varchar2(50) not null,
start_time date, 
end_time date,
switch_count number
);
create index i_redo_date on $XUNJIAN_USER.redo_log_switch (insert_date desc);
create index i_redo_host on $XUNJIAN_USER.redo_log_switch (hostname);


---------------------------------------------------------------------------------
create table $XUNJIAN_USER.tablespace_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
tablespace_name varchar2(50) not null,
total_size number,
used_size number,
free_size number,
used_percent number
);
create index i_tab_date on $XUNJIAN_USER.tablespace_useage (insert_date desc);
create index i_tab_host on $XUNJIAN_USER.tablespace_useage (hostname);


----------------------------------------------------------------------------------
create table $XUNJIAN_USER.temp_tablespace_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
tablespace_name varchar2(50) not null,
total_size number,
allocate_size number,
allocate_percent number,
used_size number,
free_size number,
used_percent number
);
create index i_temp_date on $XUNJIAN_USER.temp_tablespace_useage (insert_date desc);
create index i_temp_host on $XUNJIAN_USER.temp_tablespace_useage (hostname);


---------------------------------------------------------------------------------
create table $XUNJIAN_USER.disk_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
disk_name varchar2(100) not null,
total_size number,
used_size number,
free_size number,
used_percent number,
mounted_on varchar2(50)
);
create index i_disk_date on $XUNJIAN_USER.disk_useage (insert_date desc);
create index i_disk_host on $XUNJIAN_USER.disk_useage (hostname);


----------------------------------------------------------------------------------
create table $XUNJIAN_USER.undo_tablespace_useage (
insert_date date default sysdate,
hostname varchar2(20) not null,
tablespace_name varchar2(20) not null,
total_size number,
free_size number,
used_size number,
used_percent number,
active_size number,
unexpired_size number,
expired_size number,
active_percent number
);
create index i_undo_date on $XUNJIAN_USER.undo_tablespace_useage (insert_date desc);
create index i_undo_host on $XUNJIAN_USER.undo_tablespace_useage (hostname);

EOF
fi