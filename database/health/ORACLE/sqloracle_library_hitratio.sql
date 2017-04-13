set linesize 30
col lib for 9999
SET SQLPROMPT "SQL>";
SELECT  round(sum(PINHITS)/sum(pins)*100) lib
  FROM V$LIBRARYCACHE;
  
 quit
 
