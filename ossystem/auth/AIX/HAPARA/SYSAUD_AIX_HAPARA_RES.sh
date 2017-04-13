#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_HAPARA_RES.sh               #
# 作  者：CCSD_liyu                              #
# 日  期：2012年12月12日                         #
# 功  能：检查ha的参数                           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_HAPARA_RES.out"
> $v_logfile

if [ $(lsattr -El sys0 | awk '/^maxpout/{print $2}') -eq 8192 ];then
	:
else
	echo "sys0 maxpout is not 8192\t\t\t\tError" >> $v_logfile
fi

if [ $(lsattr -El sys0 | awk '/^minpout/{print $2}') -eq 4096 ];then
	:
else
	echo "sys0 minpout is not 4096\t\t\t\tError" >> $v_logfile
fi

if [ -s /usr/es/sbin/cluster/utilities/cllsnim ] ;then
   if [ $(/usr/es/sbin/cluster/utilities/cllsnim -g -n'rs232' | awk '/Failure Detection Rate/{print $NF}') = '(Slow)' ];then
       :
   else
       echo "rs232 Failure Detection Rate is not (Slow)\t\t\t\tError" >> $v_logfile
   fi
fi

if [ -s /usr/es/sbin/cluster/utilities/clchsyncd ] ;then
   if [ $(/usr/es/sbin/cluster/utilities/clchsyncd | awk '/syncd frequency:/{print $NF}') -eq 10 ];then
      :
   else
       echo "syncd frequency value is not 10\t\t\t\tError" >> $v_logfile
   fi
fi

if [ -s $v_logfile ];then
   echo "Non-Compliant"
else
   echo "Compliant"
   echo "合规" >> $v_logfile
fi

exit 0