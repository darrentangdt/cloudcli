sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col max_size a20
col target_size a20
spool /home/ap/opscloud/bin/scripts/tmp/oracle/DBAUD_ORA_SGATARGET_RES2.out
SELECT b.value max_size,a.value target_size from v\$parameter a,v\$parameter b where a.name ='sga_target' and b.name='sga_max_size';
spool off
EOF