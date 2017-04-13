log_dir=/home/ap/healthchecklogocssd;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_OCSSDLOGERROR_HOST.out;
select lower(host_name) from v\$instance;
spool off;
quit
