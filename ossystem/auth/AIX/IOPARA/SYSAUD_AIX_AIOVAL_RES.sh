#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_AIOVAL_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统aio设置                        #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_release=`oslevel |cut -c1`
if [ $v_release -le 5 ]; then
lsdev -Cc aio |awk '($2 == "Available") {print $0}' > SYSAUD_AIX_AIOVAL_RES.out
if [ -s SYSAUD_AIX_AIOVAL_RES.out ]; then
echo "Compliant"
echo "合规" > SYSAUD_AIX_AIOVAL_RES.out
else
echo "Non-Compliant"
echo "当前操作系统aio项未打开,属不合规" > SYSAUD_AIX_AIOVAL_RES.out
fi
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_AIOVAL_RES.out
fi





