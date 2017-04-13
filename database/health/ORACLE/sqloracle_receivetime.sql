log_dir=/home/ap/healthchecklogreceivetime;

sqlplus "/as sysdba" <<EOF
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_RECEIVETIME_RES2.out;
select ((b1.value/b2.value)*10) "avg receive time(ms)" from gv\$sysstat b1,gv\$sysstat b2 where b1.name='global cache cr block receive time' and b2.name='global cache cr blocks received' and b1.inst_id=b2.inst_id;
spool off;
quit
