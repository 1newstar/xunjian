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

select 'insert into xunjian.TEMP_TABLESPACE_USEAGE(INSERT_DATE,HOSTNAME,INSTANCE_ID,TABLESPACE_NAME,TOTAL_SIZE,ALLOCATE_SIZE,ALLOCATE_PERCENT,USED_SIZE,FREE_SIZE,USED_PERCENT)values('||INSERT_DATE||','''||HOSTNAME||''','||INSTANCE_ID||','''||TABLESPACE_NAME||''','||TOTAL_SIZE||','||ALLOCATE_SIZE||','||ALLOCATE_PERCENT||','||USED_SIZE||','||FREE_SIZE||','||USED_PERCENT||');' from 
(select 'to_date(''' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') ||
       ''',''yyyy-mm-dd hh24:mi:ss'')' INSERT_DATE,
       c.host_name HOSTNAME,
       b.inst_id INSTANCE_ID,
       a.tablespace_name,
       a.TOTAL_SIZE,
       b.ALLOCATE_SIZE,
       to_char(round((b.ALLOCATE_SIZE / a.TOTAL_SIZE) * 100, 2),'fm9999999990.00') ALLOCATE_PERCENT,
       b.USED_SIZE,
       b.FREE_SIZE,
       b.USED_PERCENT
  from (select tablespace_name, sum(bytes) / 1024 / 1024 TOTAL_SIZE
          from dba_temp_files
         group by tablespace_name) a,
       (select INST_ID,
               tablespace_name,
               total_blocks * 8 / 1024 ALLOCATE_SIZE,
               used_blocks * 8 / 1024 USED_SIZE,
               free_blocks * 8 / 1024 FREE_SIZE,
               to_char(round((used_blocks / total_blocks) * 100, 2),'fm9999999990.00') USED_PERCENT
          from gv\$sort_segment) b,
       gv\$instance c
 where a.tablespace_name = b.tablespace_name
   and b.INST_ID = c.inst_id
   and to_char(round((b.ALLOCATE_SIZE / a.TOTAL_SIZE) * 100, 2),'fm9999999990.00') > 80);
select 'select ''The SQL script TEMP_TABLESPACE_USEAGE on the '||instance_name||' has been executed'' from dual;'from  v\$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;

select 'exit' from dual;
exit    
EOF


