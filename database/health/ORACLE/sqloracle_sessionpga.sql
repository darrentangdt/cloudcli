log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set pagesize 0
set feedback off;
set termout off;
set linesize 120
spool $log_dir/DBCHK_ORA_SESSIONPGA_RES2.out;
select '['||s.sid||'-'||s.serial#||'-'||PGA_ALLOC_MEM||']' from v\$session s,v\$process p where p.addr=s.paddr and p.PGA_ALLOC_MEM/1024/1024 > $1 order by PGA_ALLOC_MEM desc;
spool off
EOF
