#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_SWAPUSED_RES.sh             #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2009年 12月30日                        #
# 功  能：检查交换区使用率                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_pgsp=`lsps -s|grep MB|sed -e 's/\%//g'|awk '{print $2}'`
v_p1=`grep "V_AIX_HEA_SWAPUSE" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`

if [ $v_pgsp -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "当前交换区使用率为[$v_pgsp]%,超过阀值[$v_p1]%" > SYSCHK_AIX_SWAPUSED_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_SWAPUSED_RES.out
    echo "lsps -s 命令显示结果为:" >> SYSCHK_AIX_SWAPUSED_RES.out
    lsps -s >> SYSCHK_AIX_SWAPUSED_RES.out
fi



exit 0;