#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_PATROL_RES.sh             #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2012年09月21日                        #
# 功  能：检查系统patrolagent进程                #
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

v_patrol=`ps -ef |grep -i "patrolagent" |grep -v "grep" |wc -l`
v_p1=`grep "V_LIN_HEA_PATROL" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`

if [ $v_patrol -ge "$v_p1" ]; then
   echo "Compliant"
   echo "正常" > SYSCHK_LINUX_PATROL_RES.out
   echo "目前系统中patrolagent的数量为:$v_patrol" >> SYSCHK_LINUX_PATROL_RES.out
   echo "ps -ef | grep -i \"patrolagent\" | grep -v \"grep\" 命令显示结果为:" >> SYSCHK_LINUX_PATROL_RES.out
   ps -ef |grep -i "patrolagent" |grep -v "grep" >> SYSCHK_LINUX_PATROL_RES.out
else
   echo "Non-Compliant"
   echo "patrolagent进程数量不等于[$v_p1]个" > SYSCHK_LINUX_PATROL_RES.out
fi

exit 0;
