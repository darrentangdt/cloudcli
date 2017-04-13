#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SYSTOOLS_RES.sh                 #
# 作  者：CCSD_liyu                              #
# 日  期：2013年 02月25日                        #
# 功  能：检查交换空间                           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSAUD_AIX_SYSTOOLS_RES.out"
>$logfile


crontab -l | grep nmon >/dev/null 2>&1
if [ "$?" -eq 0 ] ;then
  :
else
 echo "nmon not in crontab list \t\t\t\tFAIL" >> $logfile
fi

if [ -s /home/backupfile/sys/tools/perfpmr.sh ];then
   #echo "ok"
   :
else
   echo "please install perfpmr tools \t\t\t\tfail" >> $logfile
fi

if [ -s /usr/sbin/lsof ];then
   #echo "ok"
   :
else
   echo "please install lsof tools  \t\t\t\tfail" >> $logfile
fi


if [ -s "$logfile" ];then
   echo "Non-Compliant"
   echo "请配置nmon到crontab中" >> $logfile
else
   echo "Compliant"
   echo "合规" >> $logfile
fi

exit 0