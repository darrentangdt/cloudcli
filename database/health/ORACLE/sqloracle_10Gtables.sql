set linesize 300
set pagesize 10000
set feedback off
SET SQLPROMPT "SQL>";
col segment_name for a50
SELECT t.owner, t.segment_name, round(BYTES / 1024 / 1024 /1024, 3) tbsize FROM DBA_SEGMENTS t 
WHERE round(BYTES / 1024 / 1024 /1024, 3) > 10 
and segment_type!='INDEX' 
and owner in (select username from dba_users where account_status = 'OPEN' and username not in ('SYS','SYSTEM','SYSMAN'))
and segment_name not like 'SYS%$$';
quit
