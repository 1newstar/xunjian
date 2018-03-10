set linesize 8000 
set pagesize 0 
set long 2000000000 
set longchunksize 9000000 
set heading off 


select 'set heading off 'from dual;

select 'select ''The SQL script execution start at ''||to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'') from dual;'   from dual;

select 'insert into xunjian.redo_log_switch(hostname,start_time,end_time,switch_count)values('''||hostname||''','||start_time||','||end_time||','||switch_count||');' from
(with redo_log_switch as(select thread#,to_char(first_time, 'yyyy-mm-dd hh24') start_time,sysdate end_time,count(1) switch_count
    from v$log_history
   where first_time between sysdate - 60 / 1440 and sysdate
   group by to_char(first_time, 'yyyy-mm-dd hh24'), thread#)
select b.host_name hostname,
       'to_date('''||to_char(sysdate-60/1440,'yyyy-mm-dd hh24:mi:ss')||''',''yyyy-mm-dd hh24:mi:ss'')' start_time,
       'to_date('''||to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')||''',''yyyy-mm-dd hh24:mi:ss'')' end_time,
       sum(nvl(a.switch_count, 0)) switch_count
  from redo_log_switch a
 right join gv$instance b
    on a.thread# = b.inst_id
 group by b.host_name);
 
 
select 'select ''The SQL script TABLESPACE_USEAGE on the '||instance_name||' has been executed'' from dual;'from  v$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;
select 'exit' from dual;
exit
