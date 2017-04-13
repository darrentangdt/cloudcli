log_dir=/home/ap/healthchecklogmaxquerylen;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_MAXQUERYLENUNDO_RES2.out;
select maxquerylen,nospaceerrcnt from v\$undostat where maxquerylen = (select max(maxquerylen) from v\$undostat);
spool off;
quit
