log_dir=/home/ap/healthcheckparallelindex;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 150;
set linesize 150;
col index_name for a30;
col degree for 999
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_PARALLELINDEX2.out;
SELECT   OWNER||'.'||index_name index_name,DEGREE FROM   DBA_indexES WHERE   owner NOT IN ('SYSTEM', 'SYS', 'OLAPSYS','SI_INFORMTN_SCHEMA', 'MGMT_VIEW','ORDPLUGINS', 'TSMSYS', 'XDB', 'SYSMAN', 'WMSYS', 'SCOTT', 'DBSNMP','DMSYS', 'DIP', 'OUTLN', 'EXFSYS', 'ANONYMOUS', 'CTXSYS', 'ORDSYS','MDSYS', 'MDDATA') AND (DEGREE > '1' );
spool off;
quit