#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_FCSX_RES.sh                 #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查双口光通道卡是否同时接入SAN        #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_FCSX_RES.out"
> $v_logfile

v_lscfg()
{
v_Fibre_disk=$(lscfg | awk '/hdisk/{if ($4 == "EMC" || $4 == "Hitachi") {print $2}}')
for ss in $v_Fibre_disk;do
  lscfg -l $ss | awk '{print $2}'|sed 's/-W[0-9].*//g'
done
}
v_fc_disk=$(v_lscfg |uniq)
v_fc_card=$(echo $v_fc_disk | sed 's/-T[0-9].*//g')
for v_card in $v_fc_card;do
  if [ $(echo $v_fc_disk | grep $v_card |uniq |wc -l) -ne 1 ];then
     echo "$v_card FC adaper 两个端口都被使用" >> $v_logfile
  fi
done

if [ -z "$v_fc_card" ];then
   echo "Compliant"
   echo "合规" >> $v_logfile
   echo "该设备口光纤卡未连接FC盘!!!" >> $v_logfile
   exit 0
fi

if [ -s "$v_logfile" ];then
echo "Non-Compliant"
echo "主机存在双口HBA卡的两个光纤通道口同时接入SAN环境的情况" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0