log_dir=/home/ap/healthchecklogdbaroleuser;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
col grantee for a30;
col GRANTED_ROLE for a60;
spool $log_dir/DBCHK_ORA_DBAUSER_RES2.out;
select ds.grantee from dba_role_privs ds,dba_users du where ds.GRANTED_ROLE='DBA' and du.username not in('SYS','SYSMAN','SYSTEM') and du.account_status ='OPEN' and ds.grantee=du.username;
spool off;

quit
