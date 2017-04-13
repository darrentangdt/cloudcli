#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 2012/8/14
###This script is a health check script of oracle database
###排除用户指定的instance，不对其检查
#############################################################
v_p=`grep "V_ORA_HEA_INSTANCE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`


echo "查看日志：需要排除的实例名为"$v_p> $log_dir/DBCHK_ORA_INSTANCE_RES.out
echo "Log"
