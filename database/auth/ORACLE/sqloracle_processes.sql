log_dir=/home/ap/audit_processes;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 150;
set linesize 150;
col value for a30;
SET SQLPROMPT "SQL>";
spool $log_dir/DBAUD_ORA_PROCESSES1.out;
select value from v\$parameter where name='processes';
spool off;
quit
EOF
