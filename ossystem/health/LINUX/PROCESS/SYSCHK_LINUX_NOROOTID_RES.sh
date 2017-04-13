#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_NOROOTID_RES.sh           #
# 作  者：CCSD_liyu                              #
# 日  期：2012年 8月 8日                         #
# 功  能：检查是否有父进程为1的非root用户进程存在#
# 复核人：                                       #
#************************************************#
#ps -ef, 关注PPID=1，UID不是root、oracle、informix,patrol，ntp，dbus，xfs的进程。
#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/health_check/LINUX"
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

v_parent=`ps -ef |awk '{ if ( $3 == "1") print $0 }'|awk '{print $1}' |grep -vE "root|oracle|informix|patrol|ntp|dbus|xfs" |wc -l`
v_p1=`grep "V_LIN_HEA_PARENT" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="0"

if [ $v_parent -gt "$v_p1" ]
then
echo "Non-Compliant"
echo "当前系统存在[$v_parent]个父进程为1的非root用户进程" > SYSCHK_LINUX_NOROOTID_RES.out
ps -ef |awk '{ if ( $3 == "1") print $0 }'|awk '($1 != "root" && $1 != "oracle" && $1 != "informix" && $1 != "patrol" && $1 != "ntp" && $1 != "dbus" && $1 != "xfs") {print $0}' >> SYSCHK_LINUX_NOROOTID_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_LINUX_NOROOTID_RES.out
fi

exit 0;