#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_LSLVNAME_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能：检查主机lv命名
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


logfile="SYSAUD_VIOC_AIX_LSLVNAME_RES.out"
> $logfile

#检查命名是否符合XXXvNNlNNNN命名规范,范例cmpv01l0001
vg_name_on=$(lsvg -o |grep -Ev "rootvg|basevg")
for vg_name in $vg_name_on;do
	lsvg -l $vg_name | sed '1,2d' | awk '{print $1}' | grep -iv "^[a-z]\{3\}v[0-9]\{2\}l[0-9]\{4\}" | grep -iv "^[a-z]\{4\}v[0-9]\{2\}l[0-9]\{4\}" >> $logfile
done

if [ -s "$logfile" ]; then
 echo "Non-Compliant"
 echo "异常,本系统中以上 lv命名 不符合逻辑卷命名规范,ccb要求XXXvNNlNNNN命名规范,范例cmpv01l0001;" >> ${logfile}
 else
 echo "Compliant"
 echo "正常" > ${logfile}
fi

exit 0