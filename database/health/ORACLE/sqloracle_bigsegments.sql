log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_BIGSEGMENTS_RES2.out;
select segment_name from dba_segments where segment_type='TABLE' and segment_type !='TABLE PARTITION' and owner in (select username from dba_users where account_status ='OPEN' and username not in ('SYS','SYSTEM','SYSMAN')) and bytes > $1*1024*1024*1024;
spool off;
quit
