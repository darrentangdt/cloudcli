#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_MAILSIZE_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查mail日志大小                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep "V_AIX_HEA_LOGSIZE" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ -d /var/spool/mail ]; then
v_num=`ls -l /var/spool/mail |awk '($5 > '"$v_p1"' ) {print $0}' |wc -l`
if [ $v_num -gt 0 ]; then
    echo "Non-Compliant"
    echo "以下邮件文件大于阀值[$v_p1]byte" > SYSCHK_AIX_MAILSIZE_RES.out
    ls -l /var/spool/mail |awk '($5 > '"$v_p1"') {print $0}' >> SYSCHK_AIX_MAILSIZE_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_MAILSIZE_RES.out
    echo "ls -l /var/spool/mail 命令显示结果如下:" >> SYSCHK_AIX_MAILSIZE_RES.out
    ls -l /var/spool/mail >> SYSCHK_AIX_MAILSIZE_RES.out 2>&1
fi
else
     echo "Non-Compliant"
     echo "/var/spool/mail文件目录不存在" > SYSCHK_AIX_MAILSIZE_RES.out
fi


exit 0;