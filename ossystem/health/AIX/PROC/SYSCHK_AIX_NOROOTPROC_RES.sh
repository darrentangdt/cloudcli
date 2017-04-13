#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_NOROOTPROC_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查父进程为1的非root用户进程          #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_parent=`ps -ef |awk '{ if ( $3 == "1") print $0 }'|awk '{print $1}' |grep -vE "root|oracle|informix|db2|patrol|weblogic|tuxedo|mqm|websphere" |wc -l`
v_p1=`grep "V_AIX_HEA_PARUSERID" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_parent -gt "$v_p1" ]
then
echo "Non-Compliant"
echo "当前系统存在[$v_parent]个父进程为1的非root用户进程" > SYSCHK_AIX_NOROOTPROC_RES.out
ps -ef |awk '{ if ( $3 == "1") print $0 }'|awk '($1 != "root" && $1 != "oracle" && $1 != "informix" && $1 != "weblogic" && $1 != "db2" && $1 != "patrol" && $1 != "tuxedo" && $1 != "mqm" && $1 != "websphere") {print $0}' >> SYSCHK_AIX_NOROOTPROC_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_AIX_NOROOTPROC_RES.out
fi



exit 0;