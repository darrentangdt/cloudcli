set linesize 120
SET SQLPROMPT "SQL>";
col member for a80
col status for a20
select l.group#,f.member,f.status from v\$logfile f,v\$log l where f.group#=l.group# and f.type<>'ONLINE' or f.status in ('INVALID','DELETED') order by 1 asc;
quit
