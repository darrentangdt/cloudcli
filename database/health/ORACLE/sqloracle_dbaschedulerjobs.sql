log_dir=/home/ap/healthchecklog6


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_DBASCHEDULERJOBS_RES2.out;
select to_number(replace(substr(d.run_duration,4,4),' ','')) from dba_scheduler_job_run_details d,dba_scheduler_jobs j where d.job_name='GATHER_STATS_JOB' and d.status ='SUCCEEDED' and d.actual_start_date > sysdate -7 and d.job_name=j.job_name and j.state='SCHEDULED';
spool off;
quit
