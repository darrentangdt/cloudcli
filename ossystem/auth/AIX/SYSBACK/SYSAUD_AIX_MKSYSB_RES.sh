#!/bin/sh
#************************************************#
# 文件名： SYSAUD_AIX_MKSYSB_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月25日                        #
# 功  能：检查备份记录                           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep "V_AIX_AUD_MKSYSBTI" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
find /var/adm/ras -mtime +"$v_p1" -print |grep "vgbackuplog" > SYSAUD_AIX_MKSYSB_RES.out

if [ -s SYSAUD_AIX_MKSYSB_RES.out ]; then
echo "Non-Compliant"
echo "操作系统已超过[$v_p1]天未做mksysb系统备份，属不合规" > SYSAUD_AIX_MKSYSB_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_MKSYSB_RES.out
fi


