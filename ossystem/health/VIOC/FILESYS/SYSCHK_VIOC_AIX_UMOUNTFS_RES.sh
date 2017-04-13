#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_UMOUNTFS_RES.sh         #
# 作  者:CCSD_liyu                               #
# 日  期:2012年 4月27日                          #
# 功  能:检查未挂载的文件系统                    #
# 复核人:                                        #
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

#判断未挂载的文件系统
v_p1=`grep "V_AIX_HEA_UMOUNTFS" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt | awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="zzzfffaaabbbeeennn111"
lsvg -l `lsvg -o` |grep -v "N/A"|grep -v "/cdrom" |grep "closed/syncd" | grep -Ev "$v_p1"> SYSCHK_VIOC_AIX_UMOUNTFS_RES1.out

if [ -s SYSCHK_VIOC_AIX_UMOUNTFS_RES1.out ]
then
echo "Non-Compliant"
echo "异常,系统存在未挂载的文件系统,请检查" > SYSCHK_VIOC_AIX_UMOUNTFS_RES.out
cat SYSCHK_VIOC_AIX_UMOUNTFS_RES1.out >> SYSCHK_VIOC_AIX_UMOUNTFS_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_VIOC_AIX_UMOUNTFS_RES.out
fi
rm -f SYSCHK_VIOC_AIX_UMOUNTFS_RES1.out >/dev/null 2>&1

exit 0;
