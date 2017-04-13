#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_CLUSTERLOG_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查clustar.log日志是否报错            #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep "V_AIX_HEA_HAOUTKEY1" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_HEA_HAOUTKEY2" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

v_date=`date +%b\ %d`
lssrc -g cluster |grep "clstrmgrES" > SYSCHK_AIX_CLUSTERLOG_RES.out
if [ -s SYSCHK_AIX_CLUSTERLOG_RES.out ]; then
if [ -f /usr/es/adm/cluster.log ]
then
tail -100 /usr/es/adm/cluster.log |grep "$v_date" |grep -E "$v_p1|$v_p2" > SYSCHK_AIX_CLUSTERLOG_RES.out
  if [ -s SYSCHK_AIX_CLUSTERLOG_RES.out ]
  then
  echo "Non-Compliant"
  echo "cluster.log有错误日志" > SYSCHK_AIX_CLUSTERLOG_RES.out
  tail -100 /usr/es/adm/cluster.log |grep "$v_date" |grep -E "$v_p1|$v_p2" >> SYSCHK_AIX_CLUSTERLOG_RES.out
  else
  echo "Compliant"
  echo "正常" > SYSCHK_AIX_CLUSTERLOG_RES.out
  fi
else
echo "Non-Compliant"
echo "/usr/es/adm/cluster.log文件不存在" > SYSCHK_AIX_CLUSTERLOG_RES.out
fi
else
echo "Compliant"
echo "正常" > SYSCHK_AIX_CLUSTERLOG_RES.out
fi



exit 0;