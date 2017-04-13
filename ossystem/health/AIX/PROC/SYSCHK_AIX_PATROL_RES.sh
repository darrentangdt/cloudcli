#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_PATROL_RES.sh               #
# 作  者：CCSD_liyu                              #
# 日  期：2012年09月21日                         #
# 功  能：检查patrol进程数量                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep "V_AIX_HEA_PATRNUM" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

v_patrol=`ps -ef |grep -i "patrolagent" |grep -v "grep" |wc -l`
if [ $v_patrol -ge "$v_p1" ]; then
  echo "Compliant"
  echo "正常" > SYSCHK_AIX_PATROL_RES.out
  echo "当前系统中patrolagent数量为:$v_patrol" >> SYSCHK_AIX_PATROL_RES.out
  echo "ps -ef |grep -i \"patrolagent\" |grep -v \"grep\" 命令显示结果为:" >> SYSCHK_AIX_PATROL_RES.out
  ps -ef |grep -i "patrolagent" |grep -v "grep" >> SYSCHK_AIX_PATROL_RES.out
else
  echo "Non-Compliant"
  echo "ps -ef |grep -i \"patrolagent\" |grep -v \"grep\" 命令显示结果为:" >> SYSCHK_AIX_PATROL_RES.out
  ps -ef |grep -i "patrolagent" |grep -v "grep" >> SYSCHK_AIX_PATROL_RES.out
  echo "当前系统的patrolagent进程少于[$v_p1]个" >> SYSCHK_AIX_PATROL_RES.out
fi


exit 0;