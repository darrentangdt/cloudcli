log_dir=/home/ap/healthcheckmoreindex;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 100;
set linesize 150;
col owner for a20
col table_name for a50
col count for 999
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_MOREINDEX2.out;
select owner||'.'||table_name table_name,count from (select owner,table_name,count(*) count from dba_indexes where owner not in ('SYSTEM','SYS') and owner not in (select username from dba_users where ACCOUNT_STATUS<>'OPEN') group by table_name,owner) where count>$1;
spool off;
quit