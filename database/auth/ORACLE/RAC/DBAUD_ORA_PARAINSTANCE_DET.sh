#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-8-20
###This script is a health check script of oracle database
#############################################################

cat $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out