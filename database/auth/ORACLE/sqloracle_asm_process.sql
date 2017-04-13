log_dir=/home/ap/audit_asm_process;

sqlplus "/as sysasm" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 150;
set linesize 150;
col value for a30
SET SQLPROMPT "SQL>";
spool $log_dir/DBAUD_ORA_PROCESS1.out;
select value from v\$parameter where name='processes';
spool off;
quit
EOF
