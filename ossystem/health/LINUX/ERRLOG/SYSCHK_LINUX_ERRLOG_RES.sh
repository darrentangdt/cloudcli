#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_ERRLOG_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查系统错误日志                       #
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

v_time=`date -d "1 days ago" | cut -c5-10`
grep "$v_time" /var/log/messages | grep -iE "EMS Event|ERROR|SCSI|fail|warn|down" > SYSCHK_LINUX_ERRLOG_RES.out

if [ -s SYSCHK_LINUX_ERRLOG_RES.out ]; then
    echo "Non-Compliant"
    echo "请详细检查上面警告信息!!!" >> SYSCHK_LINUX_ERRLOG_RES.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_LINUX_ERRLOG_RES.out
fi

exit 0;