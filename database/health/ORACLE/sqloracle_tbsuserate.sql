log_dir=/home/ap/healthchecklogtbsrate


sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 300
col tname for a80
col rate for 999
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_TBSRATE_RES2.out;
select a.TABLESPACE_NAME||'='||round(nvl(((a.total - b.free) / a.total) * 100, 0)) rate from (select TABLESPACE_NAME, sum(bytes) / (1024 * 1024) total from sys.dba_data_files dbf where dbf.TABLESPACE_NAME not in (select upper(value) from gv\$parameter where name = 'undo_tablespace') group by TABLESPACE_NAME ) a,(select TABLESPACE_NAME, sum(bytes) / (1024 * 1024) free from sys.dba_free_space group by tablespace_name) b where a.TABLESPACE_NAME = b.TABLESPACE_NAME;
spool off;
quit;