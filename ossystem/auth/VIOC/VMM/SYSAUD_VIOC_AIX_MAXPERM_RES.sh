 #!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOC_AIX_MAXPERM_RES.sh
# 作  者：iomp_zcw
# 日  期:2014年2月10日
# 功  能：检查maxperm参数设置
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

v_logfile="SYSAUD_VIOC_AIX_MAXPERM_RES.out"
> $v_logfile
vmo -aF|awk -F= '/maxperm% =/{if($2==90){}else{print "maxperm="$2"\t\t\t\terror"}}' >> $v_logfile

if [ -s $v_logfile ]
	then
		echo "Non-Compliant"
		echo "异常,系统参数maxfree当前值为[$(vmo -aF|awk -F= '/maxperm% =/{print $0}')], 未设置为[90],属不合规" >> $v_logfile
	else
		echo "Compliant"
		echo "正常" >> $v_logfile
fi
