#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_SULOGSIZE_RES.sh            #
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


if [ -f /var/adm/sulog ]; then
v_size=`ls -l /var/adm/sulog |awk '{print $5}'`
v_p1=`grep "V_AIX_HEA_SULOGSIZE" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_size -gt "$v_p1" ]; then
    echo "Non-Compliant"
    echo "sulog文件大小[$v_size]byte,已超过阀值" > SYSCHK_AIX_SULOGSIZE_RES.out
else
    echo "Compliant"
     echo "正常" > SYSCHK_AIX_SULOGSIZE_RES.out
     echo "ls -l /var/adm/sulog 命令显示如下:" >> SYSCHK_AIX_SULOGSIZE_RES.out
     ls -l /var/adm/sulog >> SYSCHK_AIX_SULOGSIZE_RES.out 2>&1
fi
else
    echo "Non-Compliant"
    echo "系统文件/var/adm/sulog不存在" > SYSCHK_AIX_SULOGSIZE_RES.out
fi




exit 0;