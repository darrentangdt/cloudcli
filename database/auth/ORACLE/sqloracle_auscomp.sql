set feedback off;
set pagesize 150;
set linesize 150;
col VS for a50
select distinct  'AUS='||ALLOCATION_UNIT_SIZE||';'||COMPATIBILITY||';'||DATABASE_COMPATIBILITY VS FROM  v$asm_diskgroup;
quit

