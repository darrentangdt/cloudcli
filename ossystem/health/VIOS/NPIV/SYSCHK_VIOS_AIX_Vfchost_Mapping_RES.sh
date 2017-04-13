#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_Vfchost_Mapping_RES.sh  #
# 作  者:iomp_zcw		                             #
# 日  期:2014年 1月15日                          #
# 功  能:vfchost设备mapping状态检查	          	 #
# 复核人:                                        #
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
logfile=SYSCHK_VIOS_AIX_Vfchost_Mapping_RES.out

#vfchost设备mapping状态检查

vfchost_st_c=$(for vfchost in `lsdev |grep vfchost|awk '{print $1}'`
	do
		if [ X`/usr/ios/cli/ioscli lsmap -vadapter ${vfchost} -npiv|head -3|awk 'NR>2 {print $4}'` != X ]
			then
				/usr/ios/cli/ioscli lsmap -vadapter $vfchost -npiv
			fi
		done|grep Status|awk -F ":" '{print $2}'|grep NOT_LOGGED_IN|wc -l)
if [ ${vfchost_st_c} -eq 0 ]
	then
		echo "Compliant"
		echo "正常" >${logfile}
		else
		echo "Non-Compliant"
		echo "异常, 存在状态为nologin的vfchost设备,请检查 " >${logfile}

		fi
