set linesize 300
SET SQLPROMPT "SQL>";
col segment_name for a50
col partition_name for a20
col tablespace_name for a20
SELECT distinct ds.tablespace_name
  FROM dba_segments ds,
       (SELECT max(bytes) / 1024 / 1024 max,
               sum(bytes) / 1024 / 1024 sum,
               tablespace_name
          FROM dba_free_space
         GROUP by tablespace_name) dfs
 WHERE (ds.next_extent / 1024 / 1024 > nvl(dfs.max, 0) * 0.8 OR
       ds.extents >= ds.max_extents * 0.8)
   AND ds.tablespace_name = dfs.tablespace_name(+)
   AND ds.owner NOT IN ('SYS', 'SYSTEM');
quit
