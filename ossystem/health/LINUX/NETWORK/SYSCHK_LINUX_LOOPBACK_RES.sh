#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_LOOPBACK_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查网络是否有传输错误                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

v_a=0
v_a=`cat /etc/hosts |grep 127.0.0.1 |grep -v "^#" |grep "localhost" |wc -l`
if [ $v_a -eq 1 ];
then
echo "Compliant"
echo "正常" > SYSCHK_LINUX_LOOPBACK_RES.out
echo "cat /etc/hosts 命令显示如下:" >> SYSCHK_LINUX_LOOPBACK_RES.out
cat /etc/hosts >> SYSCHK_LINUX_LOOPBACK_RES.out
else
echo "Non-Compliant"
echo "主机localhost不可解析,请检查/etc/hosts文件" > SYSCHK_LINUX_LOOPBACK_RES.out
fi




exit 0;