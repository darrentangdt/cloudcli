log_dir=/home/ap/healthcheckforeignindex;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 150;
set linesize 150;
col cnamel for a30;
col owner for a20;
col constraint_name a30;
col table_name a30;
SET SQLPROMPT "SQL>";
spool $log_dir/DBCHK_ORA_FOREIGNINDEX2.out;
select owner||','||table_name||','||constraint_name from (select a.owner,b.table_name,b.constraint_name,max(decode(a.position, 1, a.column_name, null)) as cname1,max(decode(a.position, 2, a.column_name, null)) as cname2,max(decode(a.position, 3, a.column_name, null)) as cname3,max(decode(a.position, 4, a.column_name, null)) as cname4,max(decode(a.position, 5, a.column_name, null)) as cname5,max(decode(a.position, 6, a.column_name, null)) as cname6,max(decode(a.position, 7, a.column_name, null)) as cname7,max(decode(a.position, 8, a.column_name, null)) as cname8,count(*) as col_cnt from dba_cons_columns  a,dba_constraints b where a.constraint_name = b.constraint_name and   b.constraint_type = 'R' and a.owner = b.owner and a.owner NOT IN ('SYSTEM', 'SYS', 'OLAPSYS', 'SI_INFORMTN_SCHEMA','PERFSTAT','MGMT_VIEW','ORDPLUGINS', 'TSMSYS', 'XDB', 'SYSMAN', 'WMSYS', 'SCOTT', 'DBSNMP','DMSYS', 'DIP', 'OUTLN', 'EXFSYS', 'ANONYMOUS', 'CTXSYS', 'ORDSYS','MDSYS', 'MDDATA') group by b.table_name, b.constraint_name,a.owner) cons where col_cnt > all (select count(*) from dba_ind_columns i where i.table_name = cons.table_name and i.column_name in(cname1, cname2, cname3, cname4, cname5, cname6, cname7, cname8) and i.column_position <= cons.col_cnt and i.index_owner=cons.owner group by i.index_name);
spool off;
quit
