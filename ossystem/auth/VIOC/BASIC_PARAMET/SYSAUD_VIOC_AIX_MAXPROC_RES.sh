 #!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_MAXPROC_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:检查用户最大进程数
# 
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

v_maxproc=`lsattr -El sys0 |grep "maxuproc" |awk '{print $2}'`
v_p1="8192"
v_p2="16384"

if [ $v_maxproc -ge "$v_p1" ] && [ $v_maxproc -le "$v_p2" ]; then
   echo "Compliant"
   echo "正常" > SYSAUD_VIOC_AIX_MAXPROC_RES.out
   else
   echo "Non-Compliant"
   echo "异常,当前的用户最大进程数设置为[$v_maxproc],未设置为大于等于[$v_p1]并小于等于[$v_p2],属不合规" > SYSAUD_VIOC_AIX_MAXPROC_RES.out
fi