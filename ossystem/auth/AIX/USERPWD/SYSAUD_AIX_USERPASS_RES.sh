#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_USERPASS_RES.sh            #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：20010年 1月25日                        #
# 功  能：检查用户密码设置                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_USERPASS_RES.out"
> $v_logfile

v_user="sfmon opsware ctm tideway oracle informix weblogic tuxedo db2"
v_value="loginretries=10 pwdwarntime=7 histsize=10 maxage=8 minlen=6 minalpha=1 minother=1"
for user1 in $v_user;do
     grep "$user1" /etc/passwd >/dev/null 2>&1
     if [ $? -eq 0 ] ;then
     for value1 in $v_value ;do
         echo $(lsuser $user1)| grep "$value1" >/dev/null 2>&1
         if [ $? -eq 0 ];then
            :
         else
            echo "$user1 are not $value1\t\t\t\tError" >> $v_logfile
         fi
      done
     fi
done

if [ -s $v_logfile ]; then
echo "Non-Compliant"
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0