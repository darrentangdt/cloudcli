#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_STALEPP_RES.sh              #
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


#查找rootvg当中状态为stale的pp
v_st1=`lsvg rootvg |grep "STALE" |awk '{print $3,$6}'`
if [ "$v_st1" = "0 0" ]; then
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_STALEPP_RES.out
    echo "lsvg rootvg 命令显示结果为:" >> SYSCHK_AIX_STALEPP_RES.out
    lsvg rootvg >> SYSCHK_AIX_STALEPP_RES.out
else
    echo "Non-Compliant"
    echo " rootvg卷组中存在STALE状态的PV或PPS" > SYSCHK_AIX_STALEPP_RES.out
fi



exit 0;