#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOS_AIX_VIRENTPARAM_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年 1月15日
# 功  能:虚拟网卡buffer值检查
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
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1
logfile=SYSAUD_VIOS_AIX_VIRENTPARAM_RES.out
>${logfile}
for ve in ent6 ent7 ent8 ent9 ent10 ent11
	do
	lsattr -El ${ve}|awk '/max_buf_huge/{ {if ($2 = 128){print "max_buf_huge:ok;"}
									else if ($2 < 128){ print "max_buf_huge:low;"}
									else if ($2 > 128){ print "max_buf_huge:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/max_buf_large/{ {if ($2 = 256){print "max_buf_large:ok;"}
									else if ($2 < 256){ print "max_buf_large:low;"}
									else if ($2 > 256){ print "max_buf_large:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/max_buf_medium/{ {if ($2 = 1024){print "max_buf_medium:ok;"}
									else if ($2 < 1024){ print "max_buf_medium:low;"}
									else if ($2 > 1024){ print "max_buf_medium:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/max_buf_small/{ {if ($2 = 2048){print "max_buf_small:ok;"}
									else if ($2 < 2048){ print "max_buf_small:low;"}
									else if ($2 > 2048){ print "max_buf_small:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/max_buf_tiny/{ {if ($2 = 2048){print "max_buf_tiny:ok;"}
									else if ($2 < 2048){ print "max_buf_tiny:low;"}
									else if ($2 > 2048){ print "max_buf_tiny:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/min_buf_huge/{ {if ($2 = 96){print "min_buf_huge:ok;"}
									else if ($2 < 96){ print "min_buf_huge:low;"}
									else if ($2 > 96){ print "min_buf_huge:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/min_buf_large/{ {if ($2 = 96){print "min_buf_large:ok;"}
									else if ($2 < 96){ print "min_buf_large:low;"}
									else if ($2 > 96){ print "min_buf_large:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/min_buf_medium/{ {if ($2 = 512){print "min_buf_medium:ok;"}
									else if ($2 < 512){ print "min_buf_medium:low;"}
									else if ($2 > 512){ print "min_buf_medium:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/min_buf_small/{ {if ($2 = 512){print "min_buf_small:ok;"}
									else if ($2 < 512){ print "min_buf_small:low;"}
									else if ($2 > 512){ print "min_buf_small:high;"}}}' >> ${logfile}
	lsattr -El ${ve}|awk '/min_buf_tiny/{ {if ($2 = 512){print "min_buf_tiny:ok;"}
									else if ($2 < 512){ print "min_buf_tiny:low;"}
									else if ($2 > 512){ print "min_buf_tiny:high;"}}}' >> ${logfile}
done
grep -iE "low|high|ERROR" ${logfile} >/dev/null 2>&1
if [ $? -eq 0 ];then
	echo "Non-Compliant"
	echo "异常,虚拟网卡buffer值设置不合规,请检查" >> ${logfile}
else
	echo "Compliant"
	echo "正常" > ${logfile}
fi