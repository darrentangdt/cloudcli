#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20100126
###This script is a health check script of oracle database
#############################################################


cat $log_dir/DBAUD_ORA_DBFSTATUS_RES.out