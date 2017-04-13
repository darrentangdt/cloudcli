log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/as sysdba"<<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120
spool $log_dir/DBCHK_ORA_EXTSPACE_RES2.out;
SELECT ds.owner,ds.segment_name,PARTITION_NAME,ds.tablespace_name FROM dba_segments ds, (SELECT max(bytes)/1024/1024 max, sum(bytes)/1024/1024 sum, tablespace_name FROM dba_free_space GROUP by tablespace_name) dfs WHERE (ds.next_extent/1024/1024 > nvl(dfs.max, 0)*0.8 OR ds.extents >= ds.max_extents*0.8) AND ds.tablespace_name = dfs.tablespace_name (+) AND ds.owner NOT IN ('SYS','SYSTEM');
spool off
EOF
