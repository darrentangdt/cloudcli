log_dir=/home/ap/healthchecklogsgahit


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 30;
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_READRATIO_RES2.out;
SELECT 100 - round((phy.value - lob.value - dir.value)/ses.value,2)*100 "HIT" FROM v\$sysstat ses,v\$sysstat lob,v\$sysstat dir,v\$sysstat phy WHERE  ses.name = 'session logical reads' AND dir.name = 'physical reads direct' AND lob.name = 'physical reads direct (lob)' AND phy.name = 'physical reads';
quit
