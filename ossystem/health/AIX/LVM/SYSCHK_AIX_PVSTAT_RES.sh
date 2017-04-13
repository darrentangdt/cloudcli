#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_PVSTAT_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查系统pv的状态                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


lspv | awk '( $4 != "active" ) && ( $4 != "Available" ) && ( $3 != "None" ) && ( $4 != "" ) && ( $4 != "concurrent" ) { print $0; }'  > SYSCHK_AIX_PVSTAT_RES.out
lsvg -p rootvg |awk '{if ($2 != "active") print $0}' |grep -vE "PV_NAME|rootvg" >> SYSCHK_AIX_PVSTAT_RES.out
if [ -s SYSCHK_AIX_PVSTAT_RES.out ]; then
   echo "Non-Compliant"
   echo "以上PV状态异常" >> SYSCHK_AIX_PVSTAT_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_PVSTAT_RES.out
   echo "lspv 命令显示结果为:" >> SYSCHK_AIX_PVSTAT_RES.out
   lspv >> SYSCHK_AIX_PVSTAT_RES.out
   echo "lspv 命令显示结果为:" >> SYSCHK_AIX_PVSTAT_RES.out
   lspv >> SYSCHK_AIX_PVSTAT_RES.out
fi



exit 0;