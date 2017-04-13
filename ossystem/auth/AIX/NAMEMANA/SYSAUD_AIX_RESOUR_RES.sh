#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_RESOUR_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月22日                        #
# 功  能：检查双机资源组命名                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#资源组命名是否符合命名规则(xxx+yy+1位编号+res；xxx代表项目缩写，yy代表功能，编号1-9）如ocrdb1res
lssrc -g cluster |grep "clstrmgrES" > SYSAUD_AIX_RESOUR_RES.out
if [ -s SYSAUD_AIX_RESOUR_RES.out ]; then
#v_resour=`/usr/es/sbin/cluster/clstat -o |grep "Resource Group:" |wc -l`
v_resour=`/usr/es/sbin/cluster/utilities/cltopinfo |grep "Resource Group" |wc -l`
#v_resourname=`/usr/es/sbin/cluster/clstat -o |grep "Resource Group:" |awk '{print $3}' |cut -c6-9 |grep -iv "[1-9]res" |wc -l`
v_resourname=`/usr/es/sbin/cluster/utilities/cltopinfo |grep "Resource Group" |awk '{print $3}' |cut -c6-9 |grep -iv "[1-9]res" |wc -l`
#v_resourname1=`/usr/es/sbin/cluster/clstat -o |grep "Resource Group:" |awk '{print $3}' |cut -c4-5 |grep -iv "db|ap|wb|rp|op|ws|pr|ts|dc|mx|ss" |wc -l`
v_resourname1=`/usr/es/sbin/cluster/utilities/cltopinfo |grep "Resource Group" |awk '{print $3}' |cut -c4-5 |grep -iv "db|ap|wb|rp|op|ws|pr|ts|dc|mx|ss" |wc -l`
if [ $v_resour -gt 0 ]; then
 if [[ $v_resourname -gt 0 || $v_resourname1 -gt 0 ]]; then
 echo "Non-Compliant"
 echo "双机资源组命名不合命名规范" > SYSAUD_AIX_RESOUR_RES.out
#/usr/es/sbin/cluster/clstat -o |grep "Resource Group:" |awk '{print $3}' >> SYSAUD_AIX_RESOUR_RES.out
/usr/es/sbin/cluster/utilities/cltopinfo |grep "Resource Group" |awk '{print $3}' >> SYSAUD_AIX_RESOUR_RES.out
 else
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_RESOUR_RES.out
 fi
 else
 echo "Non-Compliant"
 echo "无法取得hacmp当前资源组名,请检查双机配置是否正确或clinfoES服务是否已启" > SYSAUD_AIX_RESOUR_RES.out
#/usr/es/sbin/cluster/clstat -o >/dev/null >>SYSAUD_AIX_RESOUR_RES.out 2>&1
/usr/es/sbin/cluster/utilities/cltopinfo >/dev/null >>SYSAUD_AIX_RESOUR_RES.out 2>&1
 fi
 else
 echo "Compliant"
 echo "合规" > SYSAUD_AIX_RESOUR_RES.out
fi
exit 0








