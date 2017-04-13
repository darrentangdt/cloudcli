 #!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_TCPFINW_RES.sh         #
# 作  者：iomp_zcw                               #
# 日  期：2014年3月10日                          #
# 功  能：检查系统参数tcp_finwait2设置           #
# 复核人：                                       #
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

v_logfile="SYSAUD_VIOC_AIX_TCPFINW_RES.out"
> $v_logfile
no -aF | awk -F= '/tcp_finwait2/{if ($2 == 240){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile

if [ -s $v_logfile ]
	then
		echo "Non-Compliant"
		echo "异常,系统参数当前值为[$(no -aF | awk -F= '/tcp_finwait2/{print $0}')], 未设置为[240],属不合规" >> $v_logfile
	else
		echo "Compliant"
		echo "正常" >> $v_logfile
fi

exit 0