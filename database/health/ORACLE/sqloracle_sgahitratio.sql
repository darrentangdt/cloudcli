log_dir=/home/ap/healthchecklogsgahit


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_READRATIO_RES2.out;
select a.value+b.value,c.value,round(100*(a.value+b.value-c.value)/(a.value+b.value)) from v\$sysstat a,v\$sysstat b,v\$sysstat c where a.statistic#=38 and b.statistic#=39 and c.statistic#=40;
spool off;
quit
