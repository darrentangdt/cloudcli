#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_MAILSIZE_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查mail日志大小                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/health_check/LINUX"
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

v_p1=`grep "V_LIN_HEA_MAILSIZE" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
v_num=`ls -l /var/spool/mail |awk '($5 >'"$v_p1"') {print $0}' |wc -l`
if [ $v_num -gt 0 ]; then
    echo "Non-Compliant"
    echo "以下邮件文件大于[$v_p1]byte" > SYSCHK_LINUX_MAILSIZE_RES.out
    ls -l /var/spool/mail |awk '($5 >'"$v_p1"') {print $0}' >> SYSCHK_LINUX_MAILSIZE_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_LINUX_MAILSIZE_RES.out
    echo "ls -l /var/spool/mail 命令显示结果为:" >> SYSCHK_LINUX_MAILSIZE_RES.out
    ls -l /var/spool/mail >> SYSCHK_LINUX_MAILSIZE_RES.out
fi


exit 0;