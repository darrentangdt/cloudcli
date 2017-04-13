sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col pga_target a20
spool /home/ap/opscloud/bin/scripts/tmp/oracle/DBAUD_ORA_PGATARGET_RES2.out
SELECT a.value pga_target from v\$parameter a where a.name ='pga_aggregate_target' ;
spool off
EOF