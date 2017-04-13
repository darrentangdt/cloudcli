#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_ROOTDISK_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查rootvg硬盘是否在不同背板           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_ROOTDISK_RES.out"
> $v_logfile
lspv | awk '/rootvg/{print $1}' |grep hdisk2 >/dev/null 2>&1
lscfg | awk '/hdisk/{if ($4 == "EMC" || $4 == "Hitachi") {print $2}}' | grep hdisk2 >/dev/null 
if [ $? -eq 0 ];then
   echo "Compliant"
   echo "设备只有单一背板,hdisk0和hdisk1在同一背板上!属物理配置合规" >> $v_logfile
else
   v_quorum=$(lsvg rootvg | awk '/QUORUM/{print $5}')
   if [ $v_quorum -ne 1 ] ;then
      echo "Non-Compliant"
      echo "rootvg没有做镜像" >> $v_logfile
      exit 0
   fi
   v_hdisk0=$(lspv | awk '/rootvg/{print $1}' |sed -n '1p')
   v_hdisk1=$(lspv | awk '/rootvg/{print $1}' |sed -n '2p')
   v_strings1=$(lscfg -l $v_hdisk0 |awk '{print $2}' |awk -F- '{print $1"_"$2"_"$3}')
   v_strings2=$(lscfg -l $v_hdisk1 |awk '{print $2}' |awk -F- '{print $1"_"$2"_"$3}')
   if [ "$v_strings1" = "$v_strings2" ];then
      echo "Non-Compliant"
      echo "rootvg中的主机内置盘连接在相同背板上，属不合规" >> $v_logfile 
   else
      echo "Compliant"
      echo "合规" >> $v_logfile 
   fi 
fi

exit 0

