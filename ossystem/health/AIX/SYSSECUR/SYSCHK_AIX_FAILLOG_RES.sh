#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_FAILLOG_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查登陆失败日志大小                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#判断当前登录失败日志大小
if [ -f /etc/security/failedlogin ]; then
v_size=`ls -l /etc/security/failedlogin |awk '{print $5}'`
v_p1=`grep "V_AIX_HEA_FAILSIZE" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_size -gt "v_p1" ]; then
    echo "Non-Compliant"
    echo "failedlogin文件大小[$v_size]byte,已超阀值" > SYSCHK_AIX_FAILLOG_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_FAILLOG_RES.out
    echo "ls -l /etc/security/failedlogin 名利显示结果为:" >> SYSCHK_AIX_FAILLOG_RES.out
    ls -l /etc/security/failedlogin >> SYSCHK_AIX_FAILLOG_RES.out 2>&1
fi
else
    echo "Non-Compliant"
    echo "系统文件/etc/security/failedlogin不存在" > SYSCHK_AIX_FAILLOG_RES.out
fi

exit 0;