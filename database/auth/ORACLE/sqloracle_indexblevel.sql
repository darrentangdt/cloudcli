log_dir=/home/ap/opscloud/bin/scripts/tmp/oracle;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBAUD_ORA_INDEXBLEVEL_RES2.out;
select index_name,blevel from dba_indexes where blevel >= $1 and num_rows <100000000;
spool off;
quit
EOF
