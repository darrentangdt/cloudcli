#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOC_AIX_IOBUSY_RES.sh           #
# 作  者:CCSD_YOUTONGLI                          #
# 日  期:2010年 1月4 日                          #
# 功  能:检查系统磁盘是否繁忙                    #
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

v_p1=`grep "V_AIX_HEA_IOWAIT" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_HEA_TMACT" /home/ap/opscloud/health_check/VIOC/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_iowait=`iostat |sed -n '/iowait/{n;p;}' |awk '{print $6}'`
v_busynum=`iostat -d |sed -n '/Disks:/,$p' |sed '1d' |awk '($2>'"$v_p2"') {print $0}' |wc -l`

if [ $v_iowait -gt $v_p1 ]; then
echo "当前cpu的iowait百分比为[$v_iowait]%,大于阀值[$v_p1]" >SYSCHK_VIOC_AIX_IOBUSY_RES1.out
fi

if [ $v_busynum -gt $v_p2 ]; then
echo "当前存在磁盘利用率大于阀值[$v_p2]的磁盘" >> SYSCHK_VIOC_AIX_IOBUSY_RES1.out
iostat -d >> SYSCHK_VIOC_AIX_IOBUSY_RES1.out
fi

if [ -s SYSCHK_VIOC_AIX_IOBUSY_RES1.out ]; then
   echo "Non-Compliant"
   mv SYSCHK_VIOC_AIX_IOBUSY_RES1.out SYSCHK_VIOC_AIX_IOBUSY_RES.out
   echo "异常" >>SYSCHK_VIOC_AIX_IOBUSY_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_VIOC_AIX_IOBUSY_RES.out

fi
rm -f SYSCHK_VIOC_AIX_IOBUSY_RES1.out >/dev/null 2>&1

exit 0;