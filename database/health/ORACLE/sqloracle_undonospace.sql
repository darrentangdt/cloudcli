set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
select    'NOSPACE='||max(NOSPACEERRCNT) vv from dba_hist_undostat;
quit;