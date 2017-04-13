set linesize 300
SET SQLPROMPT "SQL>";
select sysdate, startup_time,round(sysdate- startup_time) runtime from v$instance;
quit
