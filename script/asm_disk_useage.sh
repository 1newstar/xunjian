#!/bin/bash
. ~/.bash_profile


##sql environment variable##
echo set linesize 8000 
echo set pagesize 0 
echo set long 2000000000 
echo set longchunksize 9000000 
echo set heading off 

##create sql file##
sqlplus -S xunjian/oracle << EOF
set linesize 8000
set pagesize 0
set long 2000000000
set longchunksize 9000000
set heading on 
set feedback off 
set echo off
set termout off
set trimout on
set trimspool on

select 'select ''The SQL script execution start at ''||to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'') from dual;'   from dual;
select 'insert into xunjian.ASM_DISK_USEAGE(INSERT_DATE,HOSTNAME,DISK_NAME,STATE,TYPE,TOTAL_SIZE,USED_SIZE,FREE_SIZE,USED_PERCENT) values('||INSERT_DATE||','''||HOSTNAME||''','''||DISK_NAME||''','''||STATE||''','''||TYPE||''','||TOTAL_SIZE||','||USED_SIZE||','||FREE_SIZE||','||USED_PERCENT||');' from 
(select 'to_date('''||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||''',''yyyy-mm-dd hh24:mi:ss'')'INSERT_DATE,
    b.host_name HOSTNAME,
    a.name DISK_NAME,
    a.state STATE,
    a.type TYPE,
    round(a.total_mb / 1024) TOTAL_SIZE,
    round((a.total_mb - a.free_mb) / 1024) USED_SIZE,
    round(a.free_mb / 1024) FREE_SIZE,
    round((a.total_mb - a.free_mb) / a.total_mb * 100, 2)  USED_PERCENT
    from gv\$asm_diskgroup a, v\$instance b
   where a.inst_id = b.instance_number
     and round((a.total_mb - a.free_mb) / a.total_mb * 100, 2) > 80);
select 'select ''The SQL script asm_disk_useage on the '||instance_name||' has been executed'' from dual;'from  v\$instance; 
select 'select ''-----------------------------------------------------------''from dual;' from dual;

select 'exit' from dual;
exit
EOF


