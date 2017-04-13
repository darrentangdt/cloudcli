set linesize 300
select distinct bytes/1024/1024 logsize from v$log;
quit