#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_DEVICEENT_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：网卡配置是否在en设备上                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi

logfile="SYSAUD_AIX_DEVICEENT_RES.out"
>$logfile

ifconfig -a | grep "^et" >> $logfile

if [ -s "$logfile" ]; then
echo "Non-Compliant"
echo "上面网卡配置错误应配置在en设备上" >> $logfile
else
echo "Compliant"
echo "合规" >> $logfile
fi