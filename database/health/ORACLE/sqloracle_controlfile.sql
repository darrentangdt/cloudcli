set linesize 300
SET SQLPROMPT "SQL>";
col name for a100
select name from v\$controlfile where status is not null;
quit
