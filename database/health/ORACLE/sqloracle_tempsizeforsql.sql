log_dir=/home/ap/healthchecklogtempsize;

sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_TEMPSIZEFORSQL_RES2.out;
select sql_text from v\$sql sl,v\$sort_usage vs where sl.hash_value=vs.sqlhash and vs.blocks>$1*1024*1024/8192;
spool off;
quit
