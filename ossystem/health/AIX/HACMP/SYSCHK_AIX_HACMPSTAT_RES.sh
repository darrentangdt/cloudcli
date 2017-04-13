#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_HACMPSTAT_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查HACMP双机节点状态                  #
# 复核人：                                       #
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
v_node_num=`/usr/es/sbin/cluster/clstat -o | grep "Node:" |grep "UP" |wc -l`
   if [ $v_node_num -eq 2 ]; then
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_HACMPSTAT_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_AIX_HACMPSTAT_RES.out
   /usr/es/sbin/cluster/clstat -o >>SYSCHK_AIX_HACMPSTAT_RES.out  2>&1
   else
   echo "Non-Compliant"
   echo "先检查HA是否已启并且clinfo服务也一同启动,如已启动则可能存在双机节点状态异常。" > SYSCHK_AIX_HACMPSTAT_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_AIX_HACMPSTAT_RES.out   
   /usr/es/sbin/cluster/clstat -o >/dev/null >>SYSCHK_AIX_HACMPSTAT_RES.out 2>&1
   fi
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_HACMPSTAT_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_AIX_HACMPSTAT_RES.out
   /usr/es/sbin/cluster/clstat -o >>SYSCHK_AIX_HACMPSTAT_RES.out  2>&1
fi

exit 0;