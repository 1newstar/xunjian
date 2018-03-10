set linesize 8000
set pagesize 0
set long 2000000000
set longchunksize 9000000
set heading off 

select 'set heading off 'from dual;

select 'select ''The SQL script execution start at ''||to_char(sysdate,''yyyy-mm-dd hh24:mi:ss'') from dual;'   from dual;
 
select 'insert into xunjian.UNDO_TABLESPACE_USEAGE(HOSTNAME,TABLESPACE_NAME,TOTAL_SIZE,FREE_SIZE,USED_SIZE,USED_PERCENT,ACTIVE_SIZE,UNEXPIRED_SIZE,EXPIRED_SIZE,ACTIVE_PERCENT) values('''||HOSTNAME||''','''||TABLESPACE_NAME||''','||TOTAL_SIZE||','||FREE_SIZE||','||USED_SIZE||','||USED_PERCENT||','||ACTIVE_SIZE||','||UNEXPIRED_SIZE||','||EXPIRED_SIZE||','||ACTIVE_PERCENT||');' from     
(with a as (select a.tablespace_name, a.total_size, b.free_size
       from (select tablespace_name, round(sum(bytes) / 1024 / 1024) total_size
               from dba_data_files
              where tablespace_name like 'UNDO%'
              group by tablespace_name) a
       left join (select tablespace_name,
                         round(sum(bytes) / 1024 / 1024) free_size
                    from dba_free_space
                   where tablespace_name like 'UNDO%'
                   group by tablespace_name) b
         on a.tablespace_name = b.tablespace_name),     
      b as (select * from (select tablespace_name, status, bytes from dba_undo_extents) pivot(sum(bytes / 1024 / 1024) for status in('ACTIVE' ACTIVE,'UNEXPIRED' UNEXPIRED,'EXPIRED' EXPIRED))),
      c as (select a.inst_id, a.value tablespace_name, b.value instance_name from gv$parameter a, gv$parameter b where a.inst_id = b.inst_id and a.NAME = 'undo_tablespace' and b.NAME = 'instance_name')
select nvl(c.instance_name,'$HOSTNAME') HOSTNAME,
       a.tablespace_name TABLESPACE_NAME,
       a.total_size TOTAL_SIZE,
       a.free_size FREE_SIZE,
       a.total_size - a.free_size USED_SIZE,
       to_char(round((1 - a.free_size / a.total_size) * 100, 2),'fm9999999990.00') USED_PERCENT,
       nvl(round(b.ACTIVE, 2), 0) ACTIVE_SIZE,
       nvl(round(b.UNEXPIRED, 2), 0) UNEXPIRED_SIZE,
       nvl(round(b.EXPIRED, 2), 0) EXPIRED_SIZE,
       to_char(round(nvl(b.ACTIVE, 0) / (a.total_size - a.free_size) * 100, 2), 'fm9999999990.00') ACTIVE_PERCENT
  from a join b on  a.tablespace_name = b.tablespace_name left join c on a.tablespace_name = c.tablespace_name);
   
select 'select ''The SQL script UNDO_TABLESPACE_USEAGE on the '||instance_name||' has been executed'' from dual;'from  v$instance;
select 'select ''-----------------------------------------------------------''from dual;' from dual;

select 'exit' from dual;
exit



