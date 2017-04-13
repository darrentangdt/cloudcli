log_dir=/home/ap/healthcheckloglongsql;

sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120;
SET SQLPROMPT "SQL>";
col sql_text for a100;
col sql_id for a15;
spool $log_dir/DBCHK_ORA_LONGTIMESQL_RES2.out;
select distinct l.sql_address from v\$session_longops l,dba_users u where l.username=u.username and u.account_status='OPEN' and u.username not in ('SYS','SYSTEM','SYSMAN') and l.elapsed_seconds > $1;
spool off;
quit
