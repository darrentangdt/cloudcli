log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120;
col value format a20
spool $log_dir/DBCHK_ORA_PGAPERCENT_RES2.out
select round((nowpga.value/setpga.value)*100) valueNowper from v\$pgastat nowpga, v\$pgastat setpga where nowpga.name ='total PGA inuse' and setpga.NAME='aggregate PGA target parameter';
spool off
EOF
