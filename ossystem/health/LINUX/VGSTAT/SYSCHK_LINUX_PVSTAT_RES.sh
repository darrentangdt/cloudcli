#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_PVSTAT_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查卷组中pv状态                       #
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

pvdisplay >/dev/null 2>&1
if [ $? -eq 0 ]; then
pvdisplay |grep "Allocatable" |awk '{ if ($2 != "yes") print $0}' > SYSCHK_LINUX_PVSTAT_RES.out
if [ -s SYSCHK_LINUX_PVSTAT_RES.out ]; then
    echo "Non-Compliant"
    echo " 存在未分配的pv" > SYSCHK_LINUX_PVSTAT_RES.out
    pvdisplay >> SYSCHK_LINUX_PVSTAT_RES.out
    else
		echo "Compliant"
		echo "正常" > SYSCHK_LINUX_PVSTAT_RES.out
		echo "pvdisplay | grep -E \"PV Name|Allocatable\" 命令显示结果为:" >> SYSCHK_LINUX_PVSTAT_RES.out
		pvdisplay | grep -E "PV Name|Allocatable" >> SYSCHK_LINUX_PVSTAT_RES.out
fi
else
    echo "Non-Compliant"
    echo "本系统未使用LVM方式管理" > SYSCHK_LINUX_PVSTAT_RES.out
fi


exit 0;