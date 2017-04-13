#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_ROUTSTAT_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查网络路由状态                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/health_check/LINUX"
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

v_strings=`netstat -rn |grep "UG" |awk '{print $2}' |head -n 1 |grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
if [ "$v_strings" != "" ]; then
ping $v_strings -c 3 > SYSCHK_LINUX_ROUTSTAT_RES.out
if [ $? -eq 0 ];
then
echo "Compliant"
echo "正常" > SYSCHK_LINUX_ROUTSTAT_RES.out
echo "netstat -rn 命令显示如下:" >> SYSCHK_LINUX_ROUTSTAT_RES.out
netstat -rn >> SYSCHK_LINUX_ROUTSTAT_RES.out
else
echo "Non-Compliant"
echo "网关[$v_strings]不通" > SYSCHK_LINUX_ROUTSTAT_RES.out
fi
else
 echo "Non-Compliant"
 echo "系统未设网关" > SYSCHK_LINUX_ROUTSTAT_RES.out
fi




exit 0;