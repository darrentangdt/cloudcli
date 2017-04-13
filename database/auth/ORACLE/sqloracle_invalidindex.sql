set linesize 300
col owner for a50
col index_name for a50
SELECT OWNER, INDEX_NAME
  FROM dba_indexes
 WHERE status <> 'VALID'
   AND partitioned <> 'YES'
UNION ALL
SELECT INDEX_OWNER, INDEX_NAME
  FROM dba_ind_partitions
 WHERE status <> 'USABLE'
UNION ALL
SELECT INDEX_OWNER, INDEX_NAME
  FROM dba_ind_subpartitions
 WHERE status <> 'USABLE';
quit