#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_LOGINSTAT_RES.sh          #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查登录用户数                         #
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

#判断当前用户连接数
v_lognum=`who |wc -l `
v_p1=`grep "V_LIN_HEA_LOGINNUM" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`

if [ $v_lognum -gt "$v_p1" ]; then
   echo "Non-Compliant"
   echo "当前登录到主机的用户数为[$v_lognum]个,大于阀值[$v_p1]个" > SYSCHK_LINUX_LOGINSTAT_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_LINUX_LOGINSTAT_RES.out
   echo "w 命令显示结果为:" >> SYSCHK_LINUX_LOGINSTAT_RES.out
   w >> SYSCHK_LINUX_LOGINSTAT_RES.out
fi


exit 0;