set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
SELECT  'TEMPS='||round(max(TABLESPACE_USEDSIZE/TABLESPACE_SIZE)*100) used_per
FROM DBA_HIST_TBSPC_SPACE_USAGE A, v$tablespace B,DBA_HIST_SNAPSHOT C
WHERE A.TABLESPACE_ID = B.TS#
AND C.SNAP_ID = A.SNAP_ID and B.NAME like '%TEMP%'
and c.end_interval_time > sysdate - 7 ;
quit;
