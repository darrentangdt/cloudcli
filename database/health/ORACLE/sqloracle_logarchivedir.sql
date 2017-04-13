log_dir=/home/ap/healthchecklog2


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_LOGARCHIVEDIR_RES2.out;
select value from v\$parameter where name='log_archive_dest';
spool off;
quit
