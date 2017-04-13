log_dir=/home/ap/opscloud/health_check/tmp
sqlplus "/as sysdba" <<EOF
set head off;
set feedback off;
set pagesize 0;
set termout off;
set linesize 120
SET SQLPROMPT "SQL>";
col limited_cursor for a30
spool $log_dir/DBCHK_ORA_CURSORCHK_RES2.out;
select sid,limited_cursor,round(max_cursor/limited_cursor,2)*100||'%' cursor_perc from (SELECT sid,cursors-(select value from v\$parameter where name ='session_cached_cursors') max_cursor,(select value max_cursor_limit from v\$parameter where name='open_cursors' ) limited_cursor from (select sid,count(*) cursors from v\$open_cursor group by sid order by 2 desc)) where round(max_cursor/limited_cursor,2)>$1;
spool off;
EOF
