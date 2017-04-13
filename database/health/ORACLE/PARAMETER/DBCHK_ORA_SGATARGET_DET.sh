#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 20120808
###This script is a health check script of oracle database
#############################################################
#log_dir=$log_dir;

cat $log_dir/DBCHK_ORA_SGATARGET_RES.out