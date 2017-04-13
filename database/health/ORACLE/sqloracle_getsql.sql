log_dir=/home/ap/healthcheckloglongsql;

sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 100;
SET SQLPROMPT "SQL>";
col sql_fulltext for a2000;
col sql_id for a15;
spool $log_dir/DBCHK_ORA_LONGTIMESQL_RES3.out;
select sql_fulltext||';' from v\$sqlarea where address = '$1';
spool off;
quit
