log_dir=/home/ap/healthchecklog2


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_LOGARCHIVESIZE_RES2.out;
select round(sum(blocks)*8192/1024/1024) from v\$archived_log where completion_time > sysdate -4;
spool off;
quit
