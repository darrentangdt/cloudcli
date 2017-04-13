#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_LOOPBACK_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查loopback是否解析                   #
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
v_a=`cat /etc/hosts |grep 127.0.0.1 |grep -v "^#" |grep loopback |grep localhost |wc -l`
if [ $v_a -eq 1 ];
then
echo "Compliant"
echo "正常" > SYSCHK_AIX_LOOPBACK_RES.out
echo "cat /etc/hosts 命令显示如下:" >> SYSCHK_AIX_LOOPBACK_RES.out
cat /etc/hosts >> SYSCHK_AIX_LOOPBACK_RES.out
else
echo "Non-Compliant"
echo "主机loopback/localhost不可解析" > SYSCHK_AIX_LOOPBACK_RES.out
fi



exit 0;