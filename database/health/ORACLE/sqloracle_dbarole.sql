set linesize 300
SET SQLPROMPT "SQL>";
col GRANTEE for a30
col GRANTED_ROLE for a30
select * from dba_role_privs where GRANTED_ROLE='DBA' and Grantee not in('SYS','SYSMAN','SYSTEM');
quit
