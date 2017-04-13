sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col share_size a20
spool /home/ap/opscloud/bin/scripts/tmp/oracle/DBAUD_ORA_SHAREDPOOL_RES2.out
SELECT a.value share_size from v\$parameter a where a.name ='shared_pool_size' ;
spool off
EOF