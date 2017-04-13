set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
SELECT 
    TABLESPACE_NAME,STATUS
FROM   dba_tablespaces
where  status != 'ONLINE';
quit;