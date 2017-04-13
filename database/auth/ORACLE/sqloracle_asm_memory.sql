log_dir=/home/ap/audit_asm_memory;

sqlplus "/as sysasm" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 150;
set linesize 150;
col value for 99999
SET SQLPROMPT "SQL>";
spool $log_dir/DBAUD_ORA_MEMORY1.out;
select value/1024/1024 value from v\$parameter where name='memory_target';
spool off;
quit
EOF
