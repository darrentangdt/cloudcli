#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_NETSTAT_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4  日                        #
# 功  能：检查路由状态                           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_strings=`netstat -rn | grep default | awk '{print $2}'|grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'`
ping -c 5 $v_strings > SYSCHK_AIX_NETSTAT_RES.out
if [ $? -eq 0 ]; then
echo "Compliant"
echo "正常" > SYSCHK_AIX_NETSTAT_RES.out
echo "netstat -rn 命令显示结果如下:" >> SYSCHK_AIX_NETSTAT_RES.out
netstat -rn >> SYSCHK_AIX_NETSTAT_RES.out
else
echo "Non-Compliant"
echo "系统默认路由不通畅" > SYSCHK_AIX_NETSTAT_RES.out
fi



exit 0;