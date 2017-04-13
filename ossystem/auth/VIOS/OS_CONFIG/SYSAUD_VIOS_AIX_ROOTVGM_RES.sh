#!/bin/sh
#************************************************#
# 文件名：SYSAUD_VIOS_AIX_ROOTVGM_RES.sh
# 作  者：iomp_zcw
# 日  期：2014年2月10日
# 功  能：检查rootvg状态
# 复核人：
#************************************************#
export LANG=ZH_CN.UTF-8
#判断该主机是不是VIOS
if grep padmin /etc/passwd >/dev/null 2>&1
	then
	 :
	else
	exit 0
fi
#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOS_AIX_ROOTVGM_RES.out
unsync_c=$(lsvg -l rootvg 2>/dev/null|grep -v lg_dumplv|awk 'NR>2{print $6}'|grep -v syncd|wc -l)
unsync=$(lsvg -l rootvg 2>/dev/null|grep -v lg_dumplv|awk 'NR>2{print $1"\t"$6}'|grep -v syncd)
if [ ${unsync_c} -eq 0 ]
	then
	 echo "Compliant"
	 echo "正常" > ${logfile}
	else
	 echo "Non-Compliant"
	 echo "异常,当前系统中${unsync}状态不是syncd ,不合规 " >${logfile}
fi