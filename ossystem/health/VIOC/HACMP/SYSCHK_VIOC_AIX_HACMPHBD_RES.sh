#!/bin/sh
#************************************************#
# 文件名：SYSCHK_VIOC_AIX_HACMPHBD_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年3月18日
# 功  能：检查双机的心跳磁盘状态
# 复核人：
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

v_clstr=`lssrc -g cluster |grep "clstrmgrES"`
if [ ! -z "$v_clstr" ]; then
v_upnum=`/usr/es/sbin/cluster/clstat -o |awk 'flag==1 {print;flag=0} /disk/ {print;flag=1}' |grep "UP" |wc -l`
#{IGNORECASE=1} 忽略大小写问题
   if [ $v_upnum -eq 4 ]; then
   echo "Compliant"
   echo "正常" > SYSCHK_VIOC_AIX_HACMPTTY_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out
   /usr/es/sbin/cluster/clstat -o  >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out 2>&1
   echo "结束" >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out
   else
   echo "Non-Compliant"
   echo "异常,先检查HA是否已启并且clinfo服务也一同启动,如都已启动则可能存在本机双机心跳盘非up状态." > SYSCHK_VIOC_AIX_HACMPTTY_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out
   /usr/es/sbin/cluster/clstat >/dev/null >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out 2>&1
   echo "结束" >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out
   fi
   else
   echo "Compliant"
   echo "正常" > SYSCHK_VIOC_AIX_HACMPHBD_RES.out
   echo "/usr/es/sbin/cluster/clstat -o 命令显示如下:" >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out
   /usr/es/sbin/cluster/clstat -o  >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out 2>&1
   echo "结束" >>SYSCHK_VIOC_AIX_HACMPHBD_RES.out
fi


exit 0