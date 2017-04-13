#!/bin/sh
#************************************************#
# 文件名： SECAUD_AIX_SERVICES_RES.sh            
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日  
# 功  能：检查非必须服务是否禁用                 
#************************************************#

v_golbalpath=/home/ap/opscloud/security/AIX
#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/security/AIX"
log_dir="/home/ap/opscloud/logs"
cd ${log_dir} >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir ${log_dir} 
  cd ${log_dir}
fi

>SECAUD_AIX_SERVICES_RES.out


SERVICES="daytime SMTP time rexec rlogin rsh rpc.tooltalk uucp bootps finger sendmail"
#1.检查配置文件
for service in $SERVICES;do
	cat /etc/inetd.conf|grep ^$service >/dev/null       
	if [ $? -eq 0 ];then
	echo "不合规，$service服务在配置文件/etc/inetd.conf中未禁止" >>SECAUD_AIX_SERVICES_RES1.out
	fi
done

#2.检查运行状态
for service in $SERVICES;do
	lssrc -t $service|grep  active >/dev/null       
	if [ $? -eq 0 ];then
	echo "不合规，$service服务已启用" >>SECAUD_AIX_SERVICES_RES1.out
	fi
done

if [ -s "SECAUD_AIX_SERVICES_RES1.out" ];then 
echo  "Non-Compliant"
cat SECAUD_AIX_SERVICES_RES1.out >>SECAUD_AIX_SERVICES_RES.out
else
echo "Compliant"
echo "合规，daytime、SMTP、time、rexec、rlogin、rsh、rpc.tooltalk、uucp、bootps、finger等服务已禁用">>SECAUD_AIX_SERVICES_RES.out
fi

rm -f SECAUD_AIX_SERVICES_RES1.out
