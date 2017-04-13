log_dir=/home/ap/healthcheckparainstance;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 100;
set linesize 100;
col value for a40;
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_PARAINSTANCE2.out;
select instance_name||','||value value from gv\$parameter a,gv\$instance b where name='instance_groups' and a.INST_ID=b.INST_ID order by 1;
spool off;
EOF
