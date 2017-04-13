sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col process_size a20
spool /home/ap/opscloud/bin/scripts/tmp/oracle/DBAUD_ORA_PROCESSES_RES2.out
select value from v\$parameter where name ='processes';
spool off
EOF