log_dir=/home/ap/healthchecklog;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
SET SQLPROMPT "SQL>";
set linesize 1000;
col name format a20;
col value format a120;
spool $log_dir/DBCHK_ORA_ABCUMPDIRSIZE_RES2.out;
select name,value from v\$parameter where name in ('background_dump_dest','core_dump_dest','user_dump_dest','audit_file_dest');
spool off;
quit
