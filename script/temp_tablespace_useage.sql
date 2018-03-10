
set linesize 8000
set pagesize 0
set long 2000000000
set longchunksize 9000000
set heading off 

select 'set heading off 'from dual;

select 'select ''The SQL script execution start at ''||to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'') from dual;'   from dual;

select 'insert into xunjian.TEMP_TABLESPACE_USEAGE(HOSTNAME,TABLESPACE_NAME,TOTAL_SIZE,ALLOCATE_SIZE,ALLOCATE_PERCENT,USED_SIZE,FREE_SIZE,USED_PERCENT)values('''||HOSTNAME||''','''||TABLESPACE_NAME||''','||TOTAL_SIZE||','||ALLOCATE_SIZE||','||ALLOCATE_PERCENT||','||USED_SIZE||','||FREE_SIZE||','||USED_PERCENT||');' from   
  (with a as (select tablespace_name, round(sum(bytes) / 1024 / 1024) TOTAL_SIZE from dba_temp_files group by tablespace_name),
        b as (select INST_ID,tablespace_name,round(total_blocks * 8 / 1024) ALLOCATE_SIZE, round(used_blocks * 8 / 1024) USED_SIZE,round(free_blocks * 8 / 1024) FREE_SIZE,round((used_blocks / total_blocks) * 100, 2) USED_PERCENT from gv$sort_segment)
 select c.host_name HOSTNAME,
        a.tablespace_name,
        a.TOTAL_SIZE,
        b.ALLOCATE_SIZE,
        round((b.ALLOCATE_SIZE / a.TOTAL_SIZE) * 100, 2) ALLOCATE_PERCENT,
        b.USED_SIZE,
        b.FREE_SIZE,
        b.USED_PERCENT
  from  a join b on  a.tablespace_name = b.tablespace_name join gv$instance c on  b.INST_ID = c.inst_id);
   
   
select 'select ''The SQL script TEMP_TABLESPACE_USEAGE on the '||instance_name||' has been executed'' from dual;'from  v$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;

select 'exit' from dual;
exit    




