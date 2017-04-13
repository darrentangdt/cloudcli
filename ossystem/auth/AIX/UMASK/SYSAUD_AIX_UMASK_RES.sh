#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_UMASK_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查系统umask设置                      #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


>SYSAUD_AIX_UMASK_RES.out
v_umask=`cat /etc/security/user |grep -v "^*"|sed -n '/^default:/,/^root:/p'|grep umask|awk '{print $3}'`
if [ $v_umask != "022" ]; then
echo "Non-Compliant"
echo "系统umask当前值为:$v_umask;" >> SYSAUD_AIX_UMASK_RES.out
echo "不合规" >> SYSAUD_AIX_UMASK_RES.out
echo "ccb要求umask值为022" >> SYSAUD_AIX_UMASK_RES.out
else
echo "Compliant"
echo "合规" >> SYSAUD_AIX_UMASK_RES.out
fi