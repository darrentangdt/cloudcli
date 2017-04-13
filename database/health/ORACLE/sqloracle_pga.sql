set linesize 300
SET SQLPROMPT "SQL>";
select 'pgause='||round(pgause.value/pgaset.value,2)*100 xxx from v$pgastat pgause,v$pgastat pgaset where pgause.name='total PGA inuse' and pgaset.name='aggregate PGA target parameter';
quit
