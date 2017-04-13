log_dir=/home/ap/healthcheckmaxserver;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 100;
set linesize 150;
col value for 9999
col cvalue for a20
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_MAXSERVER2.out;
select a.value-(select value*$1 from v\$parameter where name='cpu_count') value,a.value cvalue from v\$parameter a where name='parallel_max_servers' ;
spool off;
quit
