set linesize 300
set pagesize 12000
set feedback off
SET SQLPROMPT "SQL>";
col account_status for a50
select username "User(s) shouldDefault Locked!",t.account_status
from dba_users t
where username in
('DBSNMP',' CTXSYS','MDSYS','ODM','ODM_MTR','ORDPLUGINS',
'ORDSYS','OUTLN','SCOTT','WK_PROXY','WK_SYS','WMSYS','XDB',
'TRACESVR','OAS_PUBLIC','WEBSYS','LBACSYS','RMAN',
'EXFSYS','SI_INFORMTN_SCHEMA')
AND account_status = 'OPEN';
quit
