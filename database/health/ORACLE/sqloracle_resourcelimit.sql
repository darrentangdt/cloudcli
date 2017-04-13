log_dir=/home/ap/healthchecklogrslimit;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_RSLIMIT_RES2.out;
select * from (select RESOURCE_NAME, CURRENT_UTILIZATION ,MAX_UTILIZATION ,1*trim(initial_allocation) INITIAL_ALLOCATION,LIMIT_VALUE from v\$resource_limit where LIMIT_VALUE not like '%UNLIMITED%') where LIMIT_VALUE > 0 and max_utilization > limit_value*$1 and RESOURCE_NAME not like 'gcs%' and RESOURCE_NAME not like 'ges%' and RESOURCE_NAME not in 'parallel_max_servers';
spool off;
quit
~
