col what for a50
set linesize 300
select job , what , failures,broken from dba_jobs where broken='Y' and failures>0;
quit