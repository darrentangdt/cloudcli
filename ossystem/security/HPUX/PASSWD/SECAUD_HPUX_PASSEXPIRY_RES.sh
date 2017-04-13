#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_PASSEXPIRY_RES.sh          
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查密码有效期策略                     
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_PASSEXPIRY_RES.out"
> $v_logfile

[ -f  Conviction.out ] && rm -f  Conviction.out

if [ -f /etc/default/security ];then 
#1.检查最长使用期限应等于60天（root无需设定）
	v_maxday=$(cat /etc/default/security|grep -v root|grep -v  ^[[:space:]]*#|grep PASSWORD_MAXDAYS |awk -F"=" '{print $2}')
   [ -z "$v_maxday" ] && v_maxday="0"
	if [ $v_maxday =  60 ];then
           echo "密码最长使用期限等于60，合规">> $v_logfile
	else
     	   echo "密码最长使用期限策略未配置为60，不合规">> Conviction.out
	fi

#2.检查密码到期提醒时间应等于7天
	v_warnday=$(cat /etc/default/security|grep -v root|grep -v  ^[[:space:]]*#|grep PASSWORD_WARNDAY |awk -F"=" '{print $2}')
   [ -z "$v_warnday" ] && v_warnday="0"
	if [ $v_warnday =  7 ];then
           echo "密码到期提醒时间等于7天，合规">> $v_logfile
	else
     	   echo "密码到期提醒时间策略未配置为7天，不合规">> Conviction.out
	fi

    if [ -s  Conviction.out ];then
   	echo "Non-Compliant"
  	cat Conviction.out >> $v_logfile
    else
        echo "Compliant"
        echo "合规" >> $v_logfile
    fi
else
    echo "Non-Compliant"
    echo "不合规，本机未配置密码有效期策略 " >> $v_logfile
fi
[ -f  Conviction.out ] && rm -f  Conviction.out
