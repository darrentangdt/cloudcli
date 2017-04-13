#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_TIMEZONE_RES.sh             #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：20010年 1月25日                        #
# 功  能：检查TZ参数是否正常                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_TIMEZONE_RES.out"
> $v_logfile

if [ $(echo $TZ) = 'Asia/Shanghai' ] || [ $(echo $TZ) = 'BEIST-8' ];then
    echo "Compliant"
    echo "合规"  >> $v_logfile
    echo "TZ is $(echo $TZ)\t\t\t\tOK" >> $v_logfile
else
    echo "Non-Compliant"
    echo "主机当前运行时区为$(echo $TZ),属不合规" >> $v_logfile
    echo "TZ is $(echo $TZ)\t\t\t\tError" >> $v_logfile
fi

exit 0
