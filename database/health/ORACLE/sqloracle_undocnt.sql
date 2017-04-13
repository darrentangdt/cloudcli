set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
select 
       'UNDOCNT='||(max(UNXPSTEALCNT) +max(UNXPBLKRELCNT)+max(UNXPBLKREUCNT)+max(EXPSTEALCNT)+max(EXPBLKRELCNT)+max(EXPBLKREUCNT)) vv 
from dba_hist_undostat;
quit;