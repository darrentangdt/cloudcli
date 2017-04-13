set feedback off;
set pagesize 150;
set linesize 150;
col name for a50
col value for a50
select name,value,isdefault from v$parameter t where t.NAME in (
'db_cache_size', 'shared_pool_size','large_pool_size','db_block_size','sp_file','log_buffer',
'pga_aggregate_target','processes', 'open_cursor', 'fast_start_mttr_target', 'max_dump_file_size')
and isdefault='TRUE';

quit