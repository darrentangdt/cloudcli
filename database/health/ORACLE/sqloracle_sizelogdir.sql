log_dir=/home/ap/healthchecklogbigsizedir;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_ARCHDIR_RES3.out;
select max(lsize)*$1 msize from (select  round(sum( blocks*block_size)/1024) lsize,to_char(completion_time,'yyyymmdd') from v\$archived_log where completion_time > sysdate -7 and thread# in (select thread# from v\$instance) and dest_id=1 group by to_char(completion_time,'yyyymmdd') order by to_char(completion_time,'yyyymmdd'));
spool off;
quit

