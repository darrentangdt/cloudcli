#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_SRCMAS_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查srcmas进程                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_a=0
v_a=`ps -ef|grep srcmstr |grep -v grep`
if [ "$v_a" = "" ]
then
echo "Non-Compliant"
echo "srcmstr进程不存在" > SYSCHK_AIX_SRCMAS_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_AIX_SRCMAS_RES.out
fi



exit 0;