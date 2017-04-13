set linesize 300
col username for a50
col account_status for a50
select username, account_status
  from dba_users
 where account_status = 'OPEN'
   and username in ('DBSNMP', 'CTXSYS', 'MDSYS', 'ODM', 'ODM_MTR',
        'ORDPLUGINS', 'ORDSYS', 'OUTLN', 'SCOTT', 'WK_PROXY',
        'WK_SYS', 'WMSYS', 'XDB', 'TRACESVR', 'OAS_PUBLIC',
        'WEBSYS', 'LBACSYS', 'EXFSYS', 'SI_INFORMTN_SCHEMA');
quit