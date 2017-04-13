log_dir=/home/ap/healthchecklogdetail;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_GETOWNER_RES2.out;
select owner||'.'||table_name from dba_tables where table_name = '$1';
spool off;
quit
