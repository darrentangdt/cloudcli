#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_DISKUNLOCKSCRIPTS_RES.sh    #
# 作  者：CCSD_liyu                              #
# 日  期：2013年03月27日                         #
# 功  能：检查disk解锁脚本是否配置               #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


logfile="SYSCHK_AIX_DISKUNLOCKSCRIPTS_RES.out"
> $logfile

if [ -s /usr/es/sbin/cluster/clstat ];then
  if [ "$(odmget HACMPdisktype |wc -l)" -eq 0 ];then
    echo "Non-Compliant"
    echo "没有配置双机磁盘解锁脚本,请检查!" >> $logfile
  else
    echo "Compliant"
    echo "正常" >> $logfile
  fi
else
  echo "Compliant"
  echo "正常,该系统未安装hacmp软件!" >> $logfile
fi

exit 0