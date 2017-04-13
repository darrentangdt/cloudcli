log_dir=/home/ap/healthchecklogprocesspga;

sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_PROCESSPGA_RES2.out;
select spid,pga_used_mem/1024/1024 pgause from v\$process where pga_used_mem > $1*1024*1024;
spool off;
quit
