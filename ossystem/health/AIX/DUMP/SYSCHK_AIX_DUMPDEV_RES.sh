#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_DUMPDEV_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：dump设备空间检查                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


/usr/lib/ras/dumpcheck -p > /dev/null >SYSCHK_AIX_DUMPDEV_RES.out 2>&1
if [ -s SYSCHK_AIX_DUMPDEV_RES.out ]
then
   echo "Non-Compliant"
   echo "dump设备空间不够用" > SYSCHK_AIX_DUMPDEV_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_DUMPDEV_RES.out
   echo "/usr/lib/ras/dumpcheck -p 命令输出结果如下"  >> SYSCHK_AIX_DUMPDEV_RES.out
   /usr/lib/ras/dumpcheck -p  >> SYSCHK_AIX_DUMPDEV_RES.out 2>&1
fi

exit 0;