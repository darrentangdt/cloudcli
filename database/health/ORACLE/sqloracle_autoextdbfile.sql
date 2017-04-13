set linesize 300
set feedback off;
set pagesize 12000
SET SQLPROMPT "SQL>";
col file_name for a150
SELECT file_name
  FROM dba_data_files
 WHERE autoextensible = 'YES'
union all
SELECT file_name
  FROM dba_temp_files
 WHERE autoextensible = 'YES';
quit
