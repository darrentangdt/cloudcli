set linesize 300
SET SQLPROMPT "SQL>";
col host_name for a50
select instance_number,instance_name,host_name,version from v$instance;
quit
