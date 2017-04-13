#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_NETRC_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查不安全文件                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_NETRC_RES.out"
> $v_logfile

if [ -f /.netrc ];then
echo "Non-Compliant"
echo "系统存在/.netrc文件，属不合规" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi
