log_dir=/home/ap/healthchecklog5;


sqlplus "/as sysdba" <<EOF
set feedback off; 
set pagesize 0; 
set termout off;
set linesize 300
SET SQLPROMPT "SQL>";
col file_name for a80
col tablespace_name for a20
col autoextensible for a10
spool $log_dir/DBCHK_ORA_DATAFILEAUTOEXTENSIBLE_RES2.out;
select tablespace_name,file_name,autoextensible from dba_data_files where autoextensible <> 'NO' union all select tablespace_name,file_name,autoextensible from dba_temp_files where autoextensible <> 'NO'; 
spool off;
quit
