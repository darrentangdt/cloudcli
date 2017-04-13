#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_NETCARD_RES.sh              #
# 作  者：CCSD_liyu                            #
# 日  期：2012年 4月5日                        #
# 功  能：检查网卡状态                           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep V_AIX_HEA_BACKUPNETCARD /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt | awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="xxxlllyyy_lll"
lsdev -Cc if |grep "`netstat -in |awk '{print $1}' |grep en`" |awk '{ if ($2 != "Available") print $0}'|grep -Ev "$v_p1" > SYSCHK_AIX_NETCARD_RES.out
if [ -s SYSCHK_AIX_NETCARD_RES.out ]
then
echo "Non-Compliant"
echo "有网卡状态不对" > SYSCHK_AIX_NETCARD_RES.out
lsdev -Cc if |grep "`netstat -in |awk '{print $1}' |grep en`" |awk '{ if ($2 != "Available") print $0}' >> SYSCHK_AIX_NETCARD_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_AIX_NETCARD_RES.out
echo "lsdev -Cc if 命令显示如下:" >> SYSCHK_AIX_NETCARD_RES.out
lsdev -Cc if >> SYSCHK_AIX_NETCARD_RES.out
fi



exit 0;