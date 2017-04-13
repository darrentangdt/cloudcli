set linesize 3000
SET SQLPROMPT "SQL>";
col name for a50
col value for a100
select name,value from v$parameter where substr(name,1,16)='log_archive_dest' and value like '%+%' or substr(name,1,16)='log_archive_dest' and value like '%/%';
quit
