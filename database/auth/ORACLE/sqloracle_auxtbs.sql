set feedback off;
set pagesize 150;
set linesize 150;
col SEGMENT_NAME for a50
col TABLESPACE_NAME for a30
select 'auxtbs='||sum(bytes) auxtbs from dba_data_files where tablespace_name='SYSAUX' group by tablespace_name;
quit
