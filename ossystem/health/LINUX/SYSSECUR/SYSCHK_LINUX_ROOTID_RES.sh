#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_ROOTID_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查系统是否存在id为0的非root用户      #
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

v_rootnum=`awk -F: '{ if ($3=="0") print $0}' /etc/passwd |wc -l`
if [ $v_rootnum -gt 1 ]; then
   echo "Non-Compliant"
   echo "系统存在id为0的非root用户" > SYSCHK_LINUX_ROOTID_RES.out
   cat /etc/passwd |awk -F: '{ if ($3=="0") print $0}' >> SYSCHK_LINUX_ROOTID_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_LINUX_ROOTID_RES.out
fi

exit 0;