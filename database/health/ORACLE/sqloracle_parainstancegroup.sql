log_dir=/home/ap/healthcheckparainstance;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 100;
set linesize 150;
set value for a30;
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_PARAINSTANCE3.out;
select value from gv\$parameter where name='parallel_instance_group' order by value;
spool off;
quit