#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_SERVICES_RES.sh            
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查非必须服务是否禁用                 
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_SERVICES_RES.out"
> $v_logfile

SERVICES="daytime SMTP time rexec rlogin rsh rpc.tooltalk uucp bootps finger"
#1.检查配置文件
for service in $SERVICES;do
	cat /etc/inetd.conf|grep ^$service >/dev/null       
	if [ $? -eq 0 ];then
	echo "不合规，$service服务在配置文件/etc/inetd.conf中未禁止" >>SECAUD_HPUX_SERVICES_RES1.out
	fi
done

#2.检查运行状态
PORTS="13 25 37 540 67 79"
for port in $PORTS;do
	netstat -an|grep -w "\*\.$port"|grep LISTEN >/dev/null       
	if [ $? -eq 0 ];then
	echo "不合规，$port端口已启用" >>SECAUD_HPUX_SERVICES_RES1.out
	fi
done

if [ -s "SECAUD_HPUX_SERVICES_RES1.out" ];then 
echo  "Non-Compliant"
cat SECAUD_HPUX_SERVICES_RES1.out >>SECAUD_HPUX_SERVICES_RES.out
else
echo "Compliant"
echo "合规，daytime、SMTP、time、rexec、rlogin、rsh、rpc.tooltalk、uucp、bootps、finger等服务已禁用">>SECAUD_HPUX_SERVICES_RES.out
fi

rm -f SECAUD_HPUX_SERVICES_RES1.out
