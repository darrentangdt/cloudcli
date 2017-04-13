set linesize 300
set pagesize 1200
SET SQLPROMPT "SQL>";
col name for a100
SELECT 'DBF='||file#||','||name||','||status
         FROM v$datafile 
         WHERE status not in ('ONLINE','SYSTEM')
         union all
SELECT 'DBF='||file#||','||name||','||status
         FROM v$tempfile 
         WHERE status <> 'ONLINE';
         
quit;
