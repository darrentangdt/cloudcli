#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_CLUSNODE_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月22日                        #
# 功  能：检查双机节点                           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


lssrc -g cluster |grep "clstrmgrES" > SYSAUD_AIX_CLUSNODE_RES.out
if [ -s SYSAUD_AIX_CLUSNODE_RES.out ]; then
v_hostname=`hostname`
#v_node=`/usr/es/sbin/cluster/clstat -o |grep "Node:" |wc -l`
v_node=`/usr/es/sbin/cluster/utilities/cltopinfo |grep NODE|wc -l`
#v_nodename=`/usr/es/sbin/cluster/clstat -o |grep "Node:" |grep "$v_hostname" |wc -l`
v_nodename=`/usr/es/sbin/cluster/utilities/cltopinfo |grep NODE |grep "$v_hostname" |wc -l`
if [ $v_node -gt 0 ]; then
 if [ $v_nodename -gt 0 ]; then
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_CLUSNODE_RES.out
 else
 echo "Non-Compliant"
 echo "当前双机的节点命名与主机名不符" > SYSAUD_AIX_CLUSNODE_RES.out
 fi
 else
 echo "Non-Compliant"
 echo "无法取得hacmp当前Node节点名,请检查双机配置是否正确或clinfoES服务是否已启" > SYSAUD_AIX_CLUSNODE_RES.out
#/usr/es/sbin/cluster/clstat -o >/dev/null >>SYSAUD_AIX_CLUSNODE_RES.out 2>&1
 /usr/es/sbin/cluster/utilities/cltopinfo >/dev/null >>SYSAUD_AIX_CLUSNODE_RES.out 2>&1
 fi
 else
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_CLUSNODE_RES.out
fi
exit 0








