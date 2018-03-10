set linesize 8000 
set pagesize 0 
set long 2000000000 
set longchunksize 9000000 
set heading off 

select 'set heading off 'from dual;

select 'select ''The SQL script execution start at ''||to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'') from dual;'   from dual;

select 'insert into xunjian.ASM_DISK_USEAGE(HOSTNAME,DISK_NAME,TOTAL_SIZE,USED_SIZE,FREE_SIZE,USED_PERCENT) values('''||HOSTNAME||''','''||DISK_NAME||''','||TOTAL_SIZE||','||USED_SIZE||','||FREE_SIZE||','||USED_PERCENT||');'from
(select b.host_name HOSTNAME,
       a.name DISK_NAME,
       round(a.total_mb / 1024) TOTAL_SIZE,
       round((a.total_mb - a.free_mb) / 1024) USED_SIZE,
       round(a.free_mb / 1024) FREE_SIZE,
       round((a.total_mb - a.free_mb) / a.total_mb * 100, 2) USED_PERCENT
  from gv$asm_diskgroup a
  join v$instance b
    on a.inst_id = b.instance_number
 where voting_files = 'N');
	 
select 'select ''The SQL script TABLESPACE_USEAGE on the '||instance_name||' has been executed'' from dual;'from  v$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;
select 'exit' from dual;
exit

