set linesize 300
col GRANTEE for a50
col GRANTED_ROLE for a50
select 'dbausers',GRANTEE,GRANTED_ROLE  from dba_role_privs where GRANTED_ROLE='DBA' and GRANTEE not in ('SYS','SYSTEM','SYSMAN','PATROL');
quit
