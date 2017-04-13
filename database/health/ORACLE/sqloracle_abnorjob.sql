set linesize 300
SET SQLPROMPT "SQL>";
SELECT 'abjobs='||count(*) xxx
  FROM dba_jobs
 WHERE broken = 'Y'
   AND failures > 0;
quit
