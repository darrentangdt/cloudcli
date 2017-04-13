#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_HACMPTTY_RES.sh             #
# 作  者：CCSD_liyu                              #
# 日  期：2012年 6月28日                         #
# 功  能：检查tty串口状态                        #
# 复核人：                                       #
# version：1.5                                   #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_clstr=`lssrc -g cluster |grep "clstrmgrES"`
if [ ! -z "$v_clstr" ]; then
v_upnum=`/usr/es/sbin/cluster/clstat -o |awk 'flag==1 {print;flag=0} /[Tt][Tt][Yy]/ {print;flag=1}' |grep "UP" |wc -l`
#{IGNORECASE=1} 忽略大小写问题
   if [ $v_upnum -eq 2 ]; then
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_HACMPTTY_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_AIX_HACMPTTY_RES.out
   /usr/es/sbin/cluster/clstat -o  >>SYSCHK_AIX_HACMPTTY_RES.out 2>&1
   echo "结束" >>SYSCHK_AIX_HACMPTTY_RES.out
   else
   echo "Non-Compliant"
   echo "先检查HA是否已启并且clinfo服务也一同启动,如都已启动则可能存在本机双机心跳串口非up状态或串口状态丢失情况。" > SYSCHK_AIX_HACMPTTY_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_AIX_HACMPTTY_RES.out 
   /usr/es/sbin/cluster/clstat >/dev/null >>SYSCHK_AIX_HACMPTTY_RES.out 2>&1
   echo "结束" >>SYSCHK_AIX_HACMPTTY_RES.out
   fi
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_HACMPTTY_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_AIX_HACMPTTY_RES.out
   /usr/es/sbin/cluster/clstat -o  >>SYSCHK_AIX_HACMPTTY_RES.out 2>&1
   echo "结束" >>SYSCHK_AIX_HACMPTTY_RES.out
fi


exit 0













