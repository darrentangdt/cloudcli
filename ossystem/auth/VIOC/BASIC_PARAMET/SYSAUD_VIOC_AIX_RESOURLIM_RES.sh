 #!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_RESOURLIM_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:检查系统资源限制情况
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

v_logfile="SYSAUD_VIOC_AIX_RESOURLIM_RES.out"
> $v_logfile

ulimit -a | awk '{if ($NF != "unlimited"){print "root user\t"$0"\t\t\tFail"}}' >> $v_logfile
if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "异常,系统存在root用户默认权限未放开的项,建议将root用户默认的limit各项设置为-1" >> $v_logfile
ulimit -a >> $v_logfile
else
echo "Compliant"
echo "正常" > $v_logfile
fi

exit 0