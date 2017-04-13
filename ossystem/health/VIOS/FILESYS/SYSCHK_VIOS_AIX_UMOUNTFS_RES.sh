#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_UMOUNTFS_RES.sh
# 作  者:CCSD_liyu
# 日  期:2012年 4月27日
# 功  能:检查未挂载的文件系统
# 复核人:
#************************************************#

#判断该台主机是不是VIOS
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		:
	else
exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opscloud/logs
  cd /home/ap/opscloud/logs
fi

#判断未挂载的文件系统

lsvg -l `lsvg -o` |grep -v "N/A"|grep -v "/cdrom" |grep "closed/syncd"> SYSCHK_VIOS_AIX_UMOUNTFS_RES1.out

if [ -s SYSCHK_VIOS_AIX_UMOUNTFS_RES1.out ]
then
echo "Non-Compliant"
echo "异常,系统存在未挂载的文件系统" >> SYSCHK_VIOS_AIX_UMOUNTFS_RES.out
cat SYSCHK_VIOS_AIX_UMOUNTFS_RES1.out >> SYSCHK_VIOS_AIX_UMOUNTFS_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_VIOS_AIX_UMOUNTFS_RES.out
fi
rm -f SYSCHK_VIOS_AIX_UMOUNTFS_RES1.out >/dev/null 2>&1

exit 0;
