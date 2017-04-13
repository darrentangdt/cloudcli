#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_ENTX_RES.sh                 #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：20010年 1月15日                        #
# 功  能：检查双口网卡是否同时接入网络           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_ENTX_RES.out"
> $v_logfile

v_ether_card_x()
{
v_ip_ent=$(netstat -in | awk '/^en/{print $1}'|uniq|sed 's/en/ent/g')
for sss in $v_ip_ent;do
  entstat -d $sss| grep  EtherChannel >/dev/null
    if [ $? -eq 0 ];then
      v_entx=$(lsattr -El $sss | grep -iE "adapter_names|backup_adapter" | awk '{print $2}')
      for v_ent1 in $v_entx;do
      lscfg -l $v_ent1 |awk '{print $2"\t'"$v_ent1"'\t'"$sss"'"}'
      done
    fi
done
}
v_p1=$(v_ether_card_x | awk '{print $NF}' |uniq)
for ss in $v_p1;do
 v_p2=$(v_ether_card_x| grep $ss |cut -c0-23|wc -l)
 if [ $v_p2 -eq 2 ];then
     :
 else
   echo "$v_p2 当前存在已配置IP地址的网口共用一块相同的双口网卡" >> $v_logfile
 fi
done

if [ -z "$v_p1" ];then
   echo "Compliant"
   echo "系统中无EtherChannel,请注意!!!" >> $v_logfile
   exit 0
fi

if [ -s $v_logfile ];then
  echo "Non-Compliant"
else
  echo "Compliant"
  echo "合规" >> $v_logfile
fi
exit 0
