#!/bin/sh
#************************************************#
# 文件名：SECAUD_HPUX_PASSINTENSITY_RESS.sh      
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日     
# 功  能：检查密码强度策略                       
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd /home/ap/opsware/script/tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p /home/ap/opsware/script/tmp
  cd /home/ap/opsware/script/tmp
fi

v_logfile="SECAUD_HPUX_PASSINTENSITY_RES.out"
> $v_logfile

[ -f  Conviction.out ] && rm -f  Conviction.out


if [ -f /etc/default/security ];then 
#1.密码最小长度应等于8
	v_length=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep MIN_PASSWORD_LENGTH |awk -F"=" '{print $2}')
   [ -z "$v_length" ] && v_length="0"
	if [ $v_length -ge 8 ];then
           echo "密码最小长度大于等于8，合规">> $v_logfile
	else
     	   echo "密码最小长度策略未配置为8，不合规">> Conviction.out
	fi

#2.密码至少包含字符类型应等于3
	v_upper=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_UPPER_CASE_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_upper" ] && v_upper="0"
	v_lower=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_LOWER_CASE_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_lower" ] && v_lower="0"
	   v_case=$(($v_upper+$v_lower))
	v_digit=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_DIGIT_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_digit" ] && v_digit="0"
	v_special=$(cat /etc/default/security|grep -v  ^[[:space:]]*#|grep PASSWORD_MIN_SPECIAL_CHARS |awk -F"=" '{print $2}')
	   [ -z "$v_special" ] && v_special="0"	   
	
	if  [ $v_case -ge 1 -a $v_digit -ge 1 -a $v_special -ge 1 ] ;then
           echo "密码至少包含3种字符类型，合规">> $v_logfile
	else
     	   echo "密码少于3种字符类型，不合规">> Conviction.out
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
    echo "不合规，本机未配置密码强度策略 " >> $v_logfile
fi
[ -f  Conviction.out ] && rm -f  Conviction.out
