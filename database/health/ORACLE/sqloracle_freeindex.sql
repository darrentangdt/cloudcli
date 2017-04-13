sqlplus "/ as sysdba" <<EOF
SET SQLPROMPT "SQL>";
set head off;
set feedback off;
set termout off;
set linesize 120
spool /home/ap/opscloud/bin/scripts/tmp/oracle/DBCHK_ORA_FREEINDEX_RES2.out;
select table_name,index_name from (select i.OWNER,i.table_name,i.index_name,s.bytes - round(i.num_rows* (c.COLUMN_LENGTH +20)*100/(100-nvl(i.pct_free,0))/1024/1024) wasted_MB,s.bytes INDEX_MB ,i.num_rows,100-round(i.num_rows* (c.COLUMN_LENGTH +20)/s.bytes/1024/1024*100) wasted_per,i.last_analyzed,c.COLUMN_LENGTH from dba_indexes i,  (select  index_owner  owner, index_name,sum(COLUMN_LENGTH) COLUMN_LENGTH from dba_ind_columns  group by index_owner  , index_name) c, (select g.owner,g.segment_name,round(sum(bytes)/1024/1024) bytes ,sum(EXTENTS) EXTENTS from dba_segments g  group by g.owner,g.segment_name) s where  c.owner=i.owner and c.index_name = i.index_name and s.owner = i.owner and s.segment_name = i.index_name and i.owner not in ('SYS','SYSTEM','OUTLN','WMSYS' ,'SYSMAN','PERFSTAT') and i.INITIAL_EXTENT *1.2  < s.bytes*1024*1024  and s.bytes  > $2 and round(nvl(i.num_rows,1)* (c.COLUMN_LENGTH +20)*100/(100-nvl(i.pct_free,0))/s.bytes/1024/1024*100) > $1 order by 4 desc);
spool off
EOF