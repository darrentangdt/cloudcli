log_dir=/home/ap/healthchecklogsystem;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
col username for a20
col default_tablespace for a50
spool $log_dir/DBCHK_ORA_DEFAULTSPACEINSYSTEM_RES2.out;
select username,default_tablespace from dba_users where account_status='OPEN' and username not in ('SYS','SYSTEM','OUTLN') and default_tablespace in ('SYSTEM','SYSAUX');
spool off;
quit
