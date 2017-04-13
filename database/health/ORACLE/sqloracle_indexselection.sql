log_dir=/home/ap/healthcheckindexselection;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 100;
set linesize 150;
col index_name for a30;
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_INDEXSELECTION2.out;
select owner||'.'||index_name index_name from dba_indexes where (distinct_keys / (num_rows+1))*100 < $1  and num_rows > 500000 and owner NOT IN ('SYSTEM','SYS','SCOTT','OLAPSYS','SI_INFORMTN_SCHEMA','MGMT_VIEW','ORDPLUGINS', 'TSMSYS', 'XDB', 'SYSMAN', 'WMSYS', 'DBSNMP','DMSYS', 'DIP', 'OUTLN', 'EXFSYS', 'ANONYMOUS', 'CTXSYS', 'ORDSYS','MDSYS', 'MDDATA') order by distinct_keys / (num_rows+1) desc;
spool off;
quit