log_dir=/home/ap/healthchecklognobackupfile;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_NOBACKUPFILEWEEK_RES2.out;
select name from v\$datafile where file# in (select file# from v\$datafile minus select file# from v\$backup_datafile where completion_time >= sysdate-$1) and creation_time < sysdate - 7;
spool off;
quit
