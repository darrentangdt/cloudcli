log_dir=/home/ap/healthchecklog4;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_BLOCKSESSION_RES2.out;
select waiting_session from dba_waiters;
spool off;
quit
