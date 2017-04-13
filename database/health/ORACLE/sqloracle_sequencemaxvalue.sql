log_dir=/home/ap/healthchecklogsequence;


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_SEQUENCEMAXVALUE_RES2.out;
select sequence_name from dba_sequences where cycle_flag='N' and round(last_number/max_value,2)*100 >= $1;
spool off;
quit
