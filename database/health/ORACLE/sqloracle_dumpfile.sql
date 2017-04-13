log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col value format a20
spool $log_dir/DBCHK_ORA_DUMPFILE_RES2.out
SELECT value from v\$parameter where name ='max_dump_file_size';
spool off
EOF
