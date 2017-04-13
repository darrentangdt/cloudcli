#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_DEFROUTE_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查当前路由信息                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


netstat -rn | grep "default" | awk '{print $2}'|grep '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' > SYSAUD_AIX_DEFROUTE_RES.out
if [ -s SYSAUD_AIX_DEFROUTE_RES.out ];
then
echo "Compliant"
echo "合规" > SYSAUD_AIX_DEFROUTE_RES.out
else
echo "Non-Compliant"
echo "系统默认路由没有设置或设置异常" > SYSAUD_AIX_DEFROUTE_RES.out
fi
