#!/bin/bash
. ~/.bash_profile

USERNAME=xunjian
PASS=oracle

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
	echo user:$user is valuable don\'t need to create it again;
else

sqlplus -S / as sysdba << EOF
create  tablespace xunjian datafile '$datafile_path/xunjian01.dbf' size 5G AUTOEXTEND ON NEXT 200M MAXSIZE 31G;
create user $USERNAME identified by $PASS default tablespace xunjian;
grant connect,resource to xunjian;
grant create any index to xunjian;
grant drop any index to xunjian;
grant select on dba_data_files to xunjian;
grant select on dba_free_space to xunjian;
grant select on dba_undo_extents to xunjian;
grant select on dba_temp_files to xunjian;
grant select on v_\$instance to xunjian;
grant select on v_\$database to xunjian;
grant select on v_\$log_history to xunjian;
grant select on gv_\$sort_segment to xunjian;
grant select on gv_\$archived_log to xunjian;
grant select on gv_\$asm_diskgroup to xunjian;
grant select on gv_\$instance to xunjian;
grant select on gv_\$parameter to xunjian;
-------------------------------------------------------------------------------
create table xunjian.cpu_useage (
insert_date date  default sysdate,
hostname varchar2(50) not null,
user_percent number ,
system_percent number ,
io_wait_percent number ,
load1 number
);
create index i_cpu_date on xunjian.cpu_useage (insert_date desc);
create index i_cpu_host on xunjian.cpu_useage (hostname);

------------------------------------------------------------------------------
create table xunjian.memory_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
memo_total number,
buffers number,
cached number,
memo_free number,
memo_used_percent number,
swap_total number,
swap_used number,
swap_free number,
swap_used_percent number
);
create index i_memo_date on xunjian.memory_useage (insert_date desc);
create index i_memo_host on xunjian.memory_useage (hostname);


----------------------------------------------------------------------------------
create table xunjian.asm_disk_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
disk_name varchar2(50) not null,
total_size number,
used_size number,
free_size number,
used_percent number
);
create index i_asmdisk_date on xunjian.asm_disk_useage (insert_date desc);
create index i_asmdisk_host on xunjian.asm_disk_useage (hostname);

------------------------------------------------------------------------------------
create table xunjian.redo_log_switch (
insert_date date default sysdate,
hostname varchar2(50) not null,
start_time date, 
end_time date,
switch_count number
);
create index i_redo_date on xunjian.redo_log_switch (insert_date desc);
create index i_redo_host on xunjian.redo_log_switch (hostname);


---------------------------------------------------------------------------------
create table xunjian.tablespace_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
tablespace_name varchar2(50) not null,
total_size number,
used_size number,
free_size number,
used_percent number
);
create index i_tab_date on xunjian.tablespace_useage (insert_date desc);
create index i_tab_host on xunjian.tablespace_useage (hostname);


----------------------------------------------------------------------------------
create table xunjian.temp_tablespace_useage (
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
create index i_temp_date on xunjian.temp_tablespace_useage (insert_date desc);
create index i_temp_host on xunjian.temp_tablespace_useage (hostname);


---------------------------------------------------------------------------------
create table xunjian.disk_useage (
insert_date date default sysdate,
hostname varchar2(50) not null,
disk_name varchar2(100) not null,
total_size number,
used_size number,
free_size number,
used_percent number,
mounted_on varchar2(50)
);
create index i_disk_date on xunjian.disk_useage (insert_date desc);
create index i_disk_host on xunjian.disk_useage (hostname);


----------------------------------------------------------------------------------
create table xunjian.undo_tablespace_useage (
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
create index i_undo_date on xunjian.undo_tablespace_useage (insert_date desc);
create index i_undo_host on xunjian.undo_tablespace_useage (hostname);

EOF
fi