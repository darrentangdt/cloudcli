#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_VGSTAT_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查卷组状态                           #
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

vgdisplay >/dev/null 2>&1
if [ $? -eq 0 ]; then
vgdisplay |grep "VG Status" |awk '{ if ($3 != "resizable") print $0}' > SYSCHK_LINUX_VGSTAT_RES.out
if [ -s SYSCHK_LINUX_VGSTAT_RES.out ]; then
    echo "Non-Compliant"
    echo " VG状态不为resizable" > SYSCHK_LINUX_VGSTAT_RES.out
    lvdisplay |grep "LV Status" |awk '{ if ($3 != "available") print $0}' >> SYSCHK_LINUX_VGSTAT_RES.out
    else
		echo "Compliant"
		echo "正常" > SYSCHK_LINUX_VGSTAT_RES.out
		echo "vgdisplay |grep -E \"VG Name|VG Status\" 命令显示结果为:" >> SYSCHK_LINUX_VGSTAT_RES.out
		vgdisplay |grep -E "VG Name|VG Status" >> SYSCHK_LINUX_VGSTAT_RES.out
		
fi
else
    echo "Non-Compliant"
    echo "本系统未使用LVM方式管理" > SYSCHK_LINUX_VGSTAT_RES.out
fi


exit 0;