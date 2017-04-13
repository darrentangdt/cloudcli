#!/bin/sh
#************************************************
# 文件名：SECAUD_AIX_PASSINTENSITY_RES.sh	         
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日                          
# 功  能：检查密码强度策略                                                  
#************************************************

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

if [ -f SECAUD_AIX_PASSINTENSITY_RES.out ]; then
	rm -f SECAUD_AIX_PASSINTENSITY_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

# 列出系统中所有用户依次检查各条目
awk -F: '{print $1}' /etc/passwd | while read v_ss
do
 set $v_ss
 lssec -f /etc/security/user -s $v_ss -a login|grep true>/dev/null 2>&1
 v_result=`echo $?`
        if [ "$v_result" -eq 0 ];then
     #表示可以登录进行检查,逐项检查minlen、minalpha及minother
     #1、检查minlen，密码最短长度
     v_minlen=`lssec -f /etc/security/user -s $v_ss -a minlen | awk -F "=" '{print $2}'`
     v_minlen_value=`cat $v_golbalpath/AIX_SEC_PARA.txt|grep V_AIX_SEC_PASSEXPIRY_minlen|awk -F "=" '{print $2}'`
     if [ ${v_minlen} -ge ${v_minlen_value} ]; then
         echo $v_ss 的minlen设置为：$v_minlen,合规>>test.out
            else
  echo $v_ss 的minlen设置为：$v_minlen,不合规>>test.out
  echo $v_ss 的minlen设置为：$v_minlen,不合规>>Conviction.out
     fi
     #2、检查minalpha，密码中至少含有多少个字母
     v_minalpha=`lssec -f /etc/security/user -s $v_ss -a minalpha | awk -F "=" '{print $2}'`
     v_minalpha_value=`cat $v_golbalpath/AIX_SEC_PARA.txt|grep V_AIX_SEC_PASSEXPIRY_minalpha|awk -F "=" '{print $2}'`
     if [ ${v_minalpha} -ge ${v_minalpha_value} ]; then
         echo $v_ss 的minalpha设置为：$v_minalpha,合规>>test.out
            else
  echo $v_ss 的minalpha设置为：$v_minalpha,不合规>>test.out
  echo $v_ss 的minalpha设置为：$v_minalpha,不合规>>Conviction.out
     fi
     #3、检查minother，密码中至少含有多少个非字母字符
     v_minother=`lssec -f /etc/security/user -s $v_ss -a minother | awk -F "=" '{print $2}'`
     v_minother_value=`cat $v_golbalpath/AIX_SEC_PARA.txt|grep V_AIX_SEC_PASSEXPIRY_minother|awk -F "=" '{print $2}'`
     if [ ${v_minother} -ge ${v_minother_value} ]; then
         echo $v_ss 的minother设置为：$v_minother,合规>>test.out
            else
  echo $v_ss 的minother设置为：$v_minother,不合规>>test.out
  echo $v_ss 的minother设置为：$v_minother,不合规>>Conviction.out
     fi
 else
     #表示不可登录，不进行其他项检查
     echo nothing>/dev/null 2>&1
 fi
done


#可能出现没有违规的情况也生成Conviction文件的情况，因此通过返回的行数来判断是否有违规的情况
test -f Conviction.out && line=`cat Conviction.out | wc -l`

#2.根据Conviction存在并且行数不为0来得到最终结果.
if [ -f Conviction.out ]; then
	if [ $line -gt 0 ]; then
		echo "Non-Compliant"
		cat test.out>>SECAUD_AIX_PASSINTENSITY_RES.out
		echo ----->>SECAUD_AIX_PASSINTENSITY_RES.out
		echo 最终结果>>SECAUD_AIX_PASSINTENSITY_RES.out
		echo ----->>SECAUD_AIX_PASSINTENSITY_RES.out
		echo "不合规">> SECAUD_AIX_PASSINTENSITY_RES.out
	else
		echo "Compliant"
		echo "合规" >> SECAUD_AIX_PASSINTENSITY_RES.out
	fi
else 
	echo "Compliant"
	echo "合规" >> SECAUD_AIX_PASSINTENSITY_RES.out
fi

if [ -f Conviction.out ]; then
	rm -f Conviction.out
fi

if [ -f test.out ]; then
	rm -f test.out
fi



exit 0;
