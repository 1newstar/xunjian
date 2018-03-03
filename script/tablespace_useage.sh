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

select 'insert into xunjian.TABLESPACE_USEAGE(INSERT_DATE,HOSTNAME,DATABASE_NAME,TABLESPACE_NAME,TOTAL_SIZE,USED_SIZE,FREE_SIZE,USED_PERCENT)
values('||INSERT_DATE||','''||HOSTNAME||''','''||DATABASE_NAME||''','''||TABLESPACE_NAME||''','||TOTAL_SIZE||','||USED_SIZE||','||FREE_SIZE||','||USED_PERCENT||');'from
(select   'to_date('''||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||''',''yyyy-mm-dd hh24:mi:ss'')'INSERT_DATE,
        c.host_name HOSTNAME,
        d.name DATABASE_NAME,
        b.tablespace_name TABLESPACE_NAME,
        a.total TOTAL_SIZE,
        a.total - b.free USED_SIZE,
        b.free FREE_SIZE,
        to_char(round(100 - (b.free/a.total) * 100),'fm9999999990.00') USED_PERCENT
    from (select tablespace_name, round(sum(bytes/1024/1024)) total
            from dba_data_files
           where tablespace_name not in ('UNDOTBS1', 'UNDOTBS2')
           group by tablespace_name) a,
         (select tablespace_name, round(sum(bytes/1024/1024)) free
            from dba_free_space
           group by tablespace_name) b,
         (select host_name from v\$instance) c,
         (select name from v\$DATABASE) d
   where a.tablespace_name = b.tablespace_name
	 and to_char(round(100 - (b.free/a.total) * 100),'fm9999999990.00')>80);  
select 'select ''The SQL script TABLESPACE_USEAGE on the '||instance_name||' has been executed'' from dual;'from  v\$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;

select 'exit' from dual;
exit      
EOF


