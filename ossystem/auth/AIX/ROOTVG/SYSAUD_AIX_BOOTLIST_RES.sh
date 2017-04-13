#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_BOOTLIST_RES.sh             #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2010年 1月15日                         #
# 功  能：检查rootvg 的启动顺序设置是否正确      #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_BOOTLIST_RES.out"
>$v_logfile
v_hdisk_number=$(lscfg |awk '/hdisk/{if ($4 == "EMC" || $4 == "Hitachi") {}else{print $2}}' |wc -l)

if [ $v_hdisk_number -eq 2 ];then
  v_hdisk0="hdisk0"
  v_hdisk1="hdisk1"
  v_boot_hdisk0=$(bootlist -m normal -o |grep -vE "cd|rmt*" |awk '/hdisk/{print $1}' |sed -n '1p')
  v_boot_hdisk1=$(bootlist -m normal -o |grep -vE "cd|rmt*" |awk '/hdisk/{print $1}' |sed -n '2p')
elif [ $v_hdisk_number -ge 4 ];then
  v_hdisk0="hdisk0"
  v_hdisk1="hdisk2"
  v_boot_hdisk0=$(bootlist -m normal -o |grep -vE "cd|rmt*" |awk '/hdisk/{print $1}' |sed -n '1p')
  v_boot_hdisk1=$(bootlist -m normal -o |grep -vE "cd|rmt*" |awk '/hdisk/{print $1}' |sed -n '2p')
fi

if [ "$v_hdisk0" = "$v_boot_hdisk0" ];then
   if [ "$v_hdisk1" = "$v_boot_hdisk1" ];then
      echo "Compliant"
      echo "合规" >> $v_logfile
   else
      echo "Non-Compliant"
      echo "硬盘启动顺序不合规" >> $v_logfile
      bootlist -m normal -o >> $v_logfile
   fi
else
   echo "Non-Compliant"
   echo "硬盘启动顺序不合规" >> $v_logfile
   bootlist -m normal -o >> $v_logfile
fi

exit 0