set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
SELECT 
    'SHAREP='||decode(sign((bytes/1024/1024)-20),-1,'1','0') results
FROM
    v$sgastat
WHERE
      pool = 'shared pool'
AND   name = 'free memory';
quit;