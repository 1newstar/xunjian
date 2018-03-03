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
set heading off 
set feedback off 
set echo off
set termout off
set trimout on
set trimspool on

select 'select ''The SQL script execution start at ''||to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'') from dual;'   from dual;

select 'insert into xunjian.REDO_LOG_SWITCH(INSERT_DATE,HOSTNAME,INSTANCE_ID,SWITCH_COUNT,SWITCH_TIME)values('||INSERT_DATE||','''||HOSTNAME||''','||INSTANCE_ID||','||SWITCH_COUNT||','||SWITCH_TIME||');' from
(select distinct'to_date(''' || to_char(sysdate, 'yyyy-mm-dd hh24:mi:ss') || ''',''yyyy-mm-dd hh24:mi:ss'')' INSERT_DATE,
       b.host_name HOSTNAME,
       0 INSTANCE_ID,
       0 SWITCH_COUNT,
       'to_date(''' || to_char(sysdate - 1/24, 'YYYY-MM-DD hh24') ||''',''yyyy-mm-dd hh24'')' SWITCH_TIME
  from v\$log_history a right join gv\$instance b
 on a.thread# = b.INST_ID
  where  0=(select count(*) from v\$log_history where first_time between  sysdate - 70/1440 and  SYSDATE - 10/1440));    
   
select 'insert into xunjian.REDO_LOG_SWITCH(INSERT_DATE,HOSTNAME,INSTANCE_ID,SWITCH_COUNT,SWITCH_TIME)values('||INSERT_DATE||','''||HOSTNAME||''','||INSTANCE_ID||','||SWITCH_COUNT||','||SWITCH_TIME||');' from
(select 'to_date('''||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||''',''yyyy-mm-dd hh24:mi:ss'')'INSERT_DATE,
       b.host_name HOSTNAME,
       a.thread# INSTANCE_ID,
       count(1) SWITCH_COUNT,
       'to_date('''||to_char(a.first_time, 'YYYY-MM-DD hh24')||''',''yyyy-mm-dd hh24'')' SWITCH_TIME
  from v\$log_history a, gv\$instance b
 where a.thread# = b.INST_ID
 and a.first_time  between  sysdate - 70/1440 and  SYSDATE - 10/1440
 group by to_char(a.first_time, 'YYYY-MM-DD hh24'), a.thread#, b.host_name);
select 'select ''The SQL script REDO_LOG_SWITCH on the '||instance_name||' has been executed'' from dual;'from  v\$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;

select 'exit' from dual;
exit
EOF


