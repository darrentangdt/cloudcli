#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_XNTPD_RES.sh                #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 01月27日                        #
# 功  能：检查xntpd服务                          #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


ps -ef  | grep -E "xntpd|ntpd" | grep -v "grep"  > SYSAUD_AIX_XNTPD_RES.out
if [ -s SYSAUD_AIX_XNTPD_RES.out ]; then
echo "Compliant"
echo "合规" > SYSAUD_AIX_XNTPD_RES.out
else
echo "Non-Compliant"
echo "未检测到xntpd/ntpd服务器时钟服务,属不合规" > SYSAUD_AIX_XNTPD_RES.out
fi