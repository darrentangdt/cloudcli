#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_VGPPSIZE_RES.sh             #
# 作  者：CCSD_liyu                              #
# 日  期：2012年12月12日                         #
# 功  能：检查应用vg中PP size大小                #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_VGPPSIZE_RES.out"
> $v_logfile

v_vgname=$(lsvg -o |grep -v rootvg)
if [ -z "$v_vgname" ];then
   echo "Compliant"
   echo "合规" > $v_logfile
   exit 0
fi

for vgn in $v_vgname;do
    v_ppsize=$(lsvg $vgn |awk '/PP SIZE:/{print $(NF-1)}')
    v_p1=$(awk -F= '/V_AIX_AUD_VGPPSIZE/{print $2}' /home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt)
    [ -z "$v_p1" ] && v_p1="128"
    if [ $v_ppsize != "$v_p1" ];then
    echo "当前rootvg 中PP SIZE的大小为[$v_vgsize],不是 $v_p1 M,属不合规" > $v_logfile
    fi
done

if [ -s $v_logfile ]; then
		echo "Non-Compliant"
else
		echo "Compliant"
    echo "合规" > $v_logfile
fi

exit 0