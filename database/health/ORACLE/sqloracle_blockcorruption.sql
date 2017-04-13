log_dir=/home/ap/healthchecklog3


sqlplus "/as sysdba" <<EOF
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_BLOCKCORRUPTION_RES2.out;
select file#,block# from v\$database_block_corruption;
spool off;
quit
