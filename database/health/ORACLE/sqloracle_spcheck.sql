set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
SELECT  'SPCHECK='||(request_failures+ABORTED_REQUESTS) vv
FROM v$shared_pool_reserved;
quit;