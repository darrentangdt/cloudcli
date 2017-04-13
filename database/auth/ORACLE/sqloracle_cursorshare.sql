sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col value format a20
spool /home/ap/opscloud/bin/scripts/tmp/oracle/DBAUD_ORA_CURSORSHARE_RES2.out
SELECT upper(value) from v\$parameter where name ='cursor_sharing';
spool off
EOF