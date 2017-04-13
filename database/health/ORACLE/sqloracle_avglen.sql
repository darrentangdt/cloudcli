set linesize 300
set feed off
SET SQLPROMPT "SQL>";
select t.table_name, t.avg_row_len from dba_tables t where t.avg_row_len>(select value from v\$parameter p where p.name='db_block_size');
quit;
