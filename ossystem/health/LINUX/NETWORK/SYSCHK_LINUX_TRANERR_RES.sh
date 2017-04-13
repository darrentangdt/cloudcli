#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_TRANERR_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查网络是否有传输错误                 #
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

v_num1=`netstat -in |grep -v "Iface" |grep -iE "eth|bond" |awk '{ print $5 }'|awk '{size+=$1}END{print size}'`
v_num2=`netstat -in |grep -v "Iface" |grep -iE "eth|bond" |awk '{ print $9 }'|awk '{size+=$1}END{print size}'`
v_p1=`grep "V_LIN_HEA_NETERROR" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`

if [[ "$v_num1" -eq "$v_p1" && "$v_num2" -eq "$v_p1" ]]
then
echo "Compliant"
echo "正常" > SYSCHK_LINUX_TRANERR_RES.out
echo "netstat -in 命令显示结果如下:" >> SYSCHK_LINUX_TRANERR_RES.out
netstat -in >> SYSCHK_LINUX_TRANERR_RES.out

else
echo "Non-Compliant"
echo "当前网卡传输错误超过[$v_p1]个" > SYSCHK_LINUX_TRANERR_RES.out
netstat -in >> SYSCHK_LINUX_TRANERR_RES.out
fi




exit 0;