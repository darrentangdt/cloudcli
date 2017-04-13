#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_FULLCORE_RES.sh         #
# 作  者:iomp_zcw                                #
# 日  期:2014年2月10日                          #
# 功  能：检查fullcore选项是否被激活             #
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
logfile=SYSAUD_VIOC_AIX_FULLCORE_RES.out
v_core=`lsattr -El sys0|grep "fullcore" |awk '{print $2}'`

if [ $v_core = "false" ]
then
echo "Non-Compliant"
echo "异常,sys0属性fullcore未设置为true,属不合规" > ${logfile}
else
echo "Compliant"
echo "正常" > ${logfile}
fi
