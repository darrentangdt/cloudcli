set linesize 300
SET SQLPROMPT "SQL>";
select index_name, status  from dba_indexes where status not in ('N/A','VALID');
quit
