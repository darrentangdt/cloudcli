#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_PRESER_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查登陆日志大小                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_size=`du -sm /var/preserve |awk '{print $1}'`
v_p1=`grep "V_AIX_HEA_PRESSIZE" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_size -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "/var/preserve目录空间为[$v_size]M,已超过阀值" > SYSCHK_AIX_PRESER_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_PRESER_RES.out
    echo "du -sm /var/preserve 命令显示如下:" >> SYSCHK_AIX_PRESER_RES.out
    du -sm /var/preserve >> SYSCHK_AIX_PRESER_RES.out
    
fi

exit 0;