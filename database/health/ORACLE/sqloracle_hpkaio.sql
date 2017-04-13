log_dir=/home/ap/healthcheckhpkaio;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 100;
set linesize 150;
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_HPKAIO_RES2.out;
select value from v\$parameter where name='processes';
spool off;
quit
