#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by YCL 20121122
###This script is a health check script of oracle database
#############################################################
#log_dir=$log_dir;

cat $log_dir/DBAUD_ORA_DBCACHESIZE_RES.out