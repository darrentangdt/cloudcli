#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_POWERERR_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查电源故障信息是否在crontab中清除    #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


crontab -l |grep "every 12" > /dev/null > SYSCHK_AIX_POWERERR_RES.out 2>&1
if [ -s SYSCHK_AIX_POWERERR_RES.out ]; then
    echo "Non-Compliant"
    echo "电源故障修复后，需要清理crontab中的every 12 hours 电源报错警告记录" > SYSCHK_AIX_POWERERR_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_POWERERR_RES.out
fi



exit 0;