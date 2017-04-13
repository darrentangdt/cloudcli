#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_DEFUNC_RES.sh             #
# 作  者：CCSD_liyu                         #
# 日  期：2012年 4月27日                        #
# 功  能：检查系统是否存在僵尸进程               #
# 复核人：                                       #
# version：1.5                                       #
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

#用户可输入多个用户,类似"grep -E "ctem|root"方式
v_p1=`grep "V_LIN_HEA_DEFUNUM" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1=0
v_UID=`grep "V_LIN_HEA_DEFUNCUID" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
[ -z "$v_UID" ] && v_UID="jfeinaekhfe jjfaheue"
v_num=`ps -ef | grep -i "defunc" | grep -Ev "$v_UID|SYSCHK_LINUX_DEFUNC_RES|grep" | wc -l`
if [ $v_num -gt $v_p1 ]; then
    echo "Non-Compliant"
	  echo "linux系统存在僵尸进程"  > SYSCHK_LINUX_DEFUNC_RES.out
	  ps -ef | grep -i "defunc" | grep -Ev "$v_UID|SYSCHK_LINUX_DEFUNC_RES|grep" >> SYSCHK_LINUX_DEFUNC_RES.out
	  else
		echo "Compliant"
		echo "正常" > SYSCHK_LINUX_DEFUNC_RES.out
	  echo "ps -ef | grep -i \"defunc\" | grep -v \"grep\"  命令显示结果为:" >> SYSCHK_LINUX_DEFUNC_RES.out
	  ps -ef | grep -i "defunc" | grep -Ev "grep|SYSCHK_LINUX_DEFUNC_RES" >> SYSCHK_LINUX_DEFUNC_RES.out
	  echo "结束" >> SYSCHK_LINUX_DEFUNC_RES.out
fi


exit 0;