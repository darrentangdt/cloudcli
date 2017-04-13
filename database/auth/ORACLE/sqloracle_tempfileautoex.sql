set linesize 300
col FILE_NAME for a50
col tablespace_name for a30
SELECT 'tempfile' file_type,file_id,file_name,tablespace_name,autoextensible 
FROM dba_temp_files WHERE autoextensible='YES';
quit