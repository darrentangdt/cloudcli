log_dir=/home/ap/healthchecklog1;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_ALERTLOGERROR_RES2.out;
select b.value||'/alert_'||d.instance_name||'.log' from v\$parameter b,v\$instance d where b.name='background_dump_dest';
spool off;
quit
