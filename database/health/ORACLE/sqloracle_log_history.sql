log_dir=/home/ap/opscloud/health_check/tmp

sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_LOGSWITCH_RES2.out;
select * from (select to_char(first_time,'yyyymmddhh24'),count(*) num from v\$log_history h1 where to_char(h1.first_time,'yyyy-mm-dd')=to_char(sysdate,'yyyy-mm-dd') group by to_char(first_time,'yyyymmddhh24')) where num > $1;
spool off;
EOF
