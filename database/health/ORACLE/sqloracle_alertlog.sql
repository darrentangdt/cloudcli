set linesize 300
SELECT value||'/alert_'||instance_name||'.log' logpath from v$parameter,v$instance WHERE name='background_dump_dest' ;
quit