#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_CLUSNAME_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月22日                        #
# 功  能：检查双机集群命名                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


lssrc -g cluster |grep "clstrmgrES" > SYSAUD_AIX_CLUSNAME_RES.out
if [ -s SYSAUD_AIX_CLUSNAME_RES.out ]; then
#v_clname=`/usr/es/sbin/cluster/clstat -o |grep "Cluster:" |awk '{print $2}'`
v_clname=`/usr/es/sbin/cluster/utilities/cltopinfo |grep "Cluster Name:" |awk '{print $3}'`

#判断集群名字母数,并且是在至少出现7个连续字母情况下的字符数
#v_clnum=`/usr/es/sbin/cluster/clstat -o |grep "Cluster:" |awk '{print $2}' |grep -i '[a-z]\{7\}' |sed 's/[^a]//' |wc -c`
v_clnum=`/usr/es/sbin/cluster/utilities/cltopinfo |grep "Cluster Name:" |awk '{print $3}' |grep -i '[a-z]\{7\}' |sed 's/[^a]//' |wc -c`
 if [ "$v_clname" != "" ]; then
 if [ $v_clnum -eq 7 ]; then
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_CLUSNAME_RES.out
 else
 echo "Non-Compliant"
 echo "当前双机的集群名称为[$v_clname],命名不符合集群命名规范。(命名规范：xxxyyzz命名原则（其中xxx代表项目名缩写，yy代表功能，cl代表cluster ，例如ocrdbcl)" > SYSAUD_AIX_CLUSNAME_RES.out
 fi
 else
 echo "Non-Compliant"
 echo "无法取得hacmp当前cluster name,请检查双机配置是否正确或clinfoES服务是否已启" > SYSAUD_AIX_CLUSNAME_RES.out
#/usr/es/sbin/cluster/clstat -o >/dev/null >>SYSAUD_AIX_CLUSNAME_RES.out 2>&1
 /usr/es/sbin/cluster/utilities/cltopinfo >/dev/null >>SYSAUD_AIX_CLUSNAME_RES.out 2>&1
 fi
 else
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_CLUSNAME_RES.out
fi
exit 0








