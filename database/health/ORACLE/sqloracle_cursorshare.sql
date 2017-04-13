log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col value format a20
spool $log_dir/DBCHK_ORA_CURSORSHARE_RES2.out
SELECT upper(value) from v\$parameter where name ='cursor_sharing';
spool off
EOF
