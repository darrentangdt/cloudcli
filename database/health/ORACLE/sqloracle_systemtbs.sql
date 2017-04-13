set linesize 300
SET SQLPROMPT "SQL>";
col segment_name for a50
col owner for a30
col TABLESPACE_NAME for a50
select OWNER, SEGMENT_NAME, TABLESPACE_NAME
  FROM Dba_segments
 where tablespace_NAME = 'SYSTEM'
   and owner not in ('DBSNMP',' CTXSYS','MDSYS','ODM','ODM_MTR','ORDPLUGINS',
'ORDSYS','OUTLN','SCOTT','WK_PROXY','WK_SYS','WMSYS','XDB',
'TRACESVR','OAS_PUBLIC','WEBSYS','LBACSYS','RMAN','PERFSTAT',
'EXFSYS','SI_INFORMTN_SCHEMA','SYS','SYSTEM')
   and owner in (select username from dba_users where account_status='OPEN');
quit
