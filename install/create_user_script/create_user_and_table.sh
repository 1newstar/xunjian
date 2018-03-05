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

CREATE TABLE xunjian.CPU_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
USER_PERCENT NUMBER NULL,
SYSTEM_PERCENT NUMBER NULL,
IO_WAIT_PERCENT NUMBER NULL,
IDLE_PERCENT NUMBER NULL,
LOAD1 NUMBER NULL,
LOAD5 NUMBER NULL,
LOAD15 NUMBER NULL
);
CREATE INDEX I_CPU_DATE ON xunjian.CPU_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_CPU_HOST ON xunjian.CPU_USEAGE (HOSTNAME DESC);


CREATE TABLE xunjian.MEMORY_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
MEMO_TOTAL NUMBER NULL,
MEMO_USED NUMBER NULL,
MEMO_FREE NUMBER NULL,
MEMO_USED_PERCENT NUMBER NULL,
SWAP_TOTAL NUMBER NULL,
SWAP_USED NUMBER NULL,
SWAP_FREE NUMBER NULL,
SWAP_USED_PERCENT NUMBER NULL
);
CREATE INDEX I_MEMO_DATE ON xunjian.MEMORY_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_MEMO_HOST ON xunjian.MEMORY_USEAGE (HOSTNAME DESC);

CREATE TABLE xunjian.ASM_DISK_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
DISK_NAME VARCHAR2(50) NOT NULL,
STATE VARCHAR2(20) NULL,
TYPE VARCHAR2(20) NULL,
TOTAL_SIZE NUMBER NULL,
USED_SIZE NUMBER NULL,
FREE_SIZE NUMBER NULL,
USED_PERCENT NUMBER NULL
);

CREATE INDEX I_ASMDISK_DATE ON xunjian.ASM_DISK_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_ASMDISK_HOST ON xunjian.ASM_DISK_USEAGE (HOSTNAME DESC);
CREATE INDEX I_ASMDISK_NAME ON xunjian.ASM_DISK_USEAGE (DISK_NAME DESC);

CREATE TABLE xunjian.REDO_LOG_SWITCH (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
INSTANCE_ID NUMBER NOT NULL,
SWITCH_COUNT NUMBER NULL,
SWITCH_TIME DATE NULL
);

CREATE INDEX I_REDO_DATE ON xunjian.REDO_LOG_SWITCH (INSERT_DATE DESC);
CREATE INDEX I_REDO_HOST ON xunjian.REDO_LOG_SWITCH (HOSTNAME DESC);

CREATE TABLE xunjian.TABLESPACE_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
DATABASE_NAME VARCHAR2(20) NOT NULL,
TABLESPACE_NAME VARCHAR2(20) NOT NULL,
TOTAL_SIZE NUMBER NULL,
USED_SIZE NUMBER NULL,
FREE_SIZE NUMBER NULL,
USED_PERCENT NUMBER NULL
);

CREATE INDEX I_TAB_DATE ON xunjian.TABLESPACE_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_TAB_HOST ON xunjian.TABLESPACE_USEAGE (HOSTNAME DESC);
CREATE INDEX I_TAB_NAME ON xunjian.TABLESPACE_USEAGE (TABLESPACE_NAME DESC);



CREATE TABLE xunjian.TEMP_TABLESPACE_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
INSTANCE_ID NUMBER(1,0) NOT NULL,
TABLESPACE_NAME VARCHAR2(20) NOT NULL,
TOTAL_SIZE NUMBER NULL,
ALLOCATE_SIZE NUMBER NULL,
ALLOCATE_PERCENT NUMBER NULL,
USED_SIZE NUMBER NULL,
FREE_SIZE NUMBER NULL,
USED_PERCENT NUMBER NULL
);

CREATE INDEX I_TEMP_DATE ON xunjian.TEMP_TABLESPACE_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_TEMP_HOST ON xunjian.TEMP_TABLESPACE_USEAGE (HOSTNAME DESC);
CREATE INDEX I_TEMP_TABNAME ON xunjian.TEMP_TABLESPACE_USEAGE (TABLESPACE_NAME DESC);


CREATE TABLE xunjian.DISK_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
DISK_NAME VARCHAR2(100) NOT NULL,
TOTAL_SIZE NUMBER NULL,
USED_SIZE NUMBER NULL,
FREE_SIZE NUMBER NULL,
USED_PERCENT NUMBER NULL,
MOUNTED_ON VARCHAR2(50) NULL
);

CREATE INDEX I_DISK_DATE ON xunjian.DISK_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_DISK_HOST ON xunjian.DISK_USEAGE (HOSTNAME DESC);
CREATE INDEX I_DISK_DISKNAME ON xunjian.DISK_USEAGE (DISK_NAME DESC);


CREATE TABLE xunjian.UNDO_TABLESPACE_USEAGE (
INSERT_DATE DATE NOT NULL,
HOSTNAME VARCHAR2(20) NOT NULL,
TABLESPACE_NAME VARCHAR2(20) NOT NULL,
TOTAL_SIZE NUMBER NULL,
FREE_SIZE NUMBER NULL,
USED_SIZE NUMBER NULL,
USED_PERCENT NUMBER NULL,
ACTIVE_SIZE NUMBER NULL,
UNEXPIRED_SIZE NUMBER NULL,
EXPIRED_SIZE NUMBER NULL,
ACTIVE_PERCENT NUMBER NULL
);

CREATE INDEX I_UNDO_DATE ON xunjian.UNDO_TABLESPACE_USEAGE (INSERT_DATE DESC);
CREATE INDEX I_UNDO_HOST ON xunjian.UNDO_TABLESPACE_USEAGE (HOSTNAME DESC);
CREATE INDEX I_UNDO_TABNAME ON xunjian.UNDO_TABLESPACE_USEAGE (TABLESPACE_NAME DESC);

EOF


fi