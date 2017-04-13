#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SWAPSP_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月22日                        #
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


logfile="SYSAUD_AIX_SWAPSP_RES.out"
>$logfile

v_lsps_current_size=$(lsps -a | awk '/hdisk/{print $4}' | sed -n 's/MB//p')
v_goodsize=$(lsattr -El mem0|awk '/goodsize/{print $2}')

if [ $v_goodsize -gt 7000 and $v_goodsize -lt 8200 ];then
   if [ $v_lsps_current_size -gt 7000 and $v_lsps_current_size -lt 8200 ];then
   :
   else
   echo "pageingspace change \t\t\t\terror"  >>$logfile
   lsps -a >>$logfile
   fi
fi

if [ $v_goodsize -gt 16000 ];then
   if [ $v_lsps_current_size -gt 15000 and $v_lsps_current_size -lt 16600 ];then
   :
   else
   echo "pageingspace change \t\t\t\terror"  >>$logfile
   lsps -a >>$logfile
   fi
fi

if [ -s "$logfile" ];then
   echo "Non-Compliant"
else
   echo "Compliant"
   echo "合规" >> $logfile
fi

exit 0



