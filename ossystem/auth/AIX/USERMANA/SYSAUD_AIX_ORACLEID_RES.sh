#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_ORACLEID_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查oracle  用户ID                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_id=`cat /etc/passwd |awk -F: '($1 == "oracle") {print $3}'`
v_p1=`grep "V_AIX_AUD_ORAIDMIN" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_AUD_ORAIDMAX" /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt |awk -F= '{print $2}'`
if [ -n "$v_id" ]; then
if [[ $v_id -le "$v_p2" && $v_id -ge "$v_p1" ]];
then
echo "Compliant"
echo "合规" > SYSAUD_AIX_ORACLEID_RES.out
else
echo "Non-Compliant"
echo "本机oracle用户ID为[$v_id],设置不在"$v_p1"至"$v_p2"之间,属不合规" > SYSAUD_AIX_ORACLEID_RES.out
fi
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_ORACLEID_RES.out
fi

