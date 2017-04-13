#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_DUMP_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:dump设置检查
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
logfile=SYSAUD_VIOC_AIX_DUMP_RES.out
>${logfile}
if [ $(sysdumpdev -l | awk '/forced copy flag/{print $NF}') = TRUE ];then
	:
else
  echo "sysdumpdev forced copy flag are not TRUE\t\t\t\tFail" >> ${logfile}
fi

if [ $(sysdumpdev -l | awk '/always allow dump/{print $NF}') = TRUE ];then
	:
else
  echo "sysdumpdev always allow dump are not TRUE\t\t\t\tFail" >> ${logfile}
fi

if [ $(sysdumpdev -l | awk '/dump compression/{print $NF}') = ON ];then
	:
else
  echo "sysdumpdev dump compression are not ON\t\t\t\tFail" >> ${logfile}
fi

if [ $(sysdumpdev -l | awk '/^copy directory/{print $NF}') = "/home/coredump" ];then
	:
else
  echo "sysdumpdev copy directory are not /home/coredump\t\t\t\tFail" >> ${logfile}
fi

if [ "$(df -m |awk '/coredump/{print $2}' | sed -e 's/.00//g')" -eq 10240 ];then
  :
else
  echo "/home/coredump (lvname=rootvgl0002) size not 10G" >> ${logfile}
fi

v_x_pp_size=$(lspv hdisk0 | awk  '/^PP SIZE/{print $3}')
v_x_dump_pp=$(lsvg -l rootvg | awk '/sysdump/{print $3}')
if [ $(echo "$v_x_pp_size * $v_x_dump_pp" | bc) -eq 8192 ];then
  :
else
   echo "lg_dumplv (sysdumpdev device) size not 10G" >> ${logfile}
fi

if [ -s ${logfile} ]
	then
		echo "Non-Compliant"
		echo "异常,dump设置不合规,请检查" >> ${logfile}
	else
		echo "Compliant"
		echo "正常" > ${logfile}
fi