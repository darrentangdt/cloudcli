log_dir=/home/ap/healthcheckloglogbuffer;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_LOGBUFFERSIZE_RES2.out;
select round(retry.value/entry.value*100,0) from v\$sysstat retry,v\$sysstat entry where retry.name='redo buffer allocation retries' and entry.name='redo entries';
spool off;
quit
