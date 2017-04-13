set linesize 300
set feedback off;
set pagesize 1200
SET SQLPROMPT "SQL>";
SELECT
    'ROWCH='||owner||','||table_name||','||'partition_name'||','||num_rows||','||num_rows||','||ROUND((chain_cnt/num_rows)*100, 2)||','||avg_row_len
FROM
    (select
         owner
       , table_name
       , chain_cnt
       , num_rows
       , avg_row_len 
     from
         sys.dba_tables 
     where
           chain_cnt is not null 
       and num_rows is not null 
       and chain_cnt > 0 
       and num_rows > 0 
       and owner != 'SYS')
WHERE
    (chain_cnt/num_rows)*100 > 10  
UNION ALL 
SELECT
    'ROWCH='||table_owner||','||table_name||','||partition_name||','||num_rows||','||num_rows||','||ROUND((chain_cnt/num_rows)*100, 2)||','||avg_row_len               
FROM
    (select
         table_owner
       , table_name
       , partition_name
       , chain_cnt
       , num_rows
       , avg_row_len 
     from
         sys.dba_tab_partitions 
     where
           chain_cnt is not null 
       and num_rows is not null 
       and chain_cnt > 0 
       and num_rows > 0 
       and table_owner != 'SYS') b 
WHERE
    (chain_cnt/num_rows)*100 > 10;
quit;