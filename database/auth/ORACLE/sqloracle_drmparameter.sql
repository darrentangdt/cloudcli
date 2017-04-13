log_dir=/home/ap/opscloud/bin/scripts/tmp/oracle;

sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
col limited_cursor for a30
spool $log_dir/DBAUD_ORA_DRMPARAMETER_RES2.out;
select nam.ksppinm||'='||val.ksppstvl from x\$ksppi   nam,x\$ksppsv  val where nam.indx = val.indx and nam.KSPPINM = '_gc_policy_time';
spool off;
EOF
