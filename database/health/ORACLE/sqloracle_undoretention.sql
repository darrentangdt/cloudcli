set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
select   'UNDORETENTION='||max(TUNED_UNDORETENTION)||','||min(TUNED_UNDORETENTION) vv from dba_hist_undostat;
quit;