set feedback off;
set pagesize 150;
set linesize 150;
col SEGMENT_NAME for a50
col TABLESPACE_NAME for a30
select 'xxxx='||value from v$parameter where name ='background_dump_dest';
quit
