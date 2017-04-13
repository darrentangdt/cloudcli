#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_LVSTAT_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查卷组中lv状态                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

lvdisplay >/dev/null 2>&1
if [ $? -eq 0 ]; then
lvdisplay |grep "LV Status" |awk '{ if ($3 != "available") print $0}' > SYSCHK_LINUX_LVSTAT_RES.out
if [ -s SYSCHK_LINUX_LVSTAT_RES.out ]; then
    echo "Non-Compliant"
    echo "系统存在不可用的逻辑卷" > SYSCHK_LINUX_LVSTAT_RES.out
    lvdisplay |grep "LV Status" |awk '{ if ($3 != "available") print $0}' >> SYSCHK_LINUX_LVSTAT_RES.out
    else
		echo "Compliant"
		echo "正常" > SYSCHK_LINUX_LVSTAT_RES.out
		echo "lvs 命令显示结果为:" >> SYSCHK_LINUX_LVSTAT_RES.out
		lvs >> SYSCHK_LINUX_LVSTAT_RES.out
fi
else
    echo "Non-Compliant"
    echo "本系统未使用LVM方式管理" > SYSCHK_LINUX_LVSTAT_RES.out
fi


exit 0;