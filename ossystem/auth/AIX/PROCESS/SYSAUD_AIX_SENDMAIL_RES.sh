#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SENDMAIL_RES.sh             #
# 作  者：CCSD_liyu                              #
# 日  期：2012年 03月27日                        #
# 功  能：检查sendmail服务                       #
# version：   1.0                                #              
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


> SYSAUD_AIX_SENDMAIL_RES.out

lssrc -s sendmail |awk '/inoperative/{if($NF == "inoperative"){}else{print $0}}' >> SYSAUD_AIX_SENDMAIL_RES.out

if [ -s "SYSAUD_AIX_SENDMAIL_RES.out" ];then
  echo "Non-Compliant"
  echo "sendmail not close" >> SYSAUD_AIX_SENDMAIL_RES.out
else
  echo "Compliant"
  echo "合规" >> SYSAUD_AIX_SENDMAIL_RES.out
fi
