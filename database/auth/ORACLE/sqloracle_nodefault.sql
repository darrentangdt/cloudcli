log_dir=/home/ap/audit_nodefault;

sqlplus "/as sysdba" <<EOF
set head off;
set termout off;
set feedback off;
set pagesize 150;
set linesize 150;
col name for a30;
col value for a50;
SET SQLPROMPT "SQL>";
spool $log_dir/DBAUD_ORA_NODEFAULT1.out;
select name,value,ISDEFAULT from v\$parameter where  ISDEFAULT ='FALSE' and name not in ('control_files','db_block_size','undo_tablespace','remote_login_passwordfile','db_domain','dispatchers','job_queue_processes','background_dump_dest','user_dump_dest','core_dump_dest','audit_file_dest','db_name','max_dump_file_size','session_cached_cursors','processes','shared_pool_size','sessions','db_cache_size','sga_max_size','sga_target','instance_groups','parallel_instance_group','_gc_undo_affinity','_gc_affinity_time','parallel_max_server','open_cursors','log_archive_dest_1','backup_tape_io_slaves','pga_aggregate_target','undo_management','compatible','db_file_multiblock_read_count');
spool off;
quit
EOF
