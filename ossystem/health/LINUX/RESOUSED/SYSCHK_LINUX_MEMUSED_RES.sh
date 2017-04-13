#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_MEMUSED_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查使用内存最多的进程                 #
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

v_p1=`grep "V_LIN_HEA_MEMPROC" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`
ps auxwww |sed '1d' |awk '( $4 > '"$v_p1"' ) {print $0}' > SYSCHK_LINUX_MEMUSED_RES.out
if [ -s SYSCHK_LINUX_MEMUSED_RES.out ]; then
    echo "Non-Compliant"
    echo "以下为内存使用率超过[$v_p1]%的进程" > SYSCHK_LINUX_MEMUSED_RES.out
    ps auxwww |head -n 1 >> SYSCHK_LINUX_MEMUSED_RES.out
    ps auxwww |sed '1d' |awk '( $4 > '"$v_p1"' ) {print $0}' >> SYSCHK_LINUX_MEMUSED_RES.out
    else
    echo "Compliant"
		echo "正常" > SYSCHK_LINUX_MEMUSED_RES.out
fi



exit 0;