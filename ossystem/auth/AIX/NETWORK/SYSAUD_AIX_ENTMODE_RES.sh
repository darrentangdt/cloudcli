#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_ENTMODE_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查系统中网卡工作模式                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


lsdev -Cc adapter | grep -v "EtherChannel" |awk '{print $1}' |grep "ent" |while read ss ;do
v_num=`lsattr -El $ss |grep "Auto_Negotiation" |wc -l`
if [ $v_num -eq 0 ]; then
echo 网卡"$ss"未设置为自适应状态 >> SYSAUD_AIX_ENTMODE_RES1.out
fi
done

if [ -s SYSAUD_AIX_ENTMODE_RES1.out ]; then
echo "Non-Compliant"
mv SYSAUD_AIX_ENTMODE_RES1.out SYSAUD_AIX_ENTMODE_RES.out
else
echo "Compliant"
echo "合规" >SYSAUD_AIX_ENTMODE_RES.out
fi
rm -f SYSAUD_AIX_ENTMODE_RES1.out >/dev/null 2>&1
