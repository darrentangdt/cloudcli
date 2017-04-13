set pagesize 0
set linesize 300
set feedback off;
SET SQLPROMPT "SQL>";
col object_name for a80
select object_name  from dba_objects o,dba_users u where o.owner=u.username and u.account_status='OPEN' and o.status !='VALID' order by OWNER,OBJECT_TYPE;
quit
