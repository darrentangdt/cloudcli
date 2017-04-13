#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_VGMAXPVNUM_RES.sh           #
# 作  者：CCSD_liyu                               #
# 日  期：2012年12月12日                         #
# 功  能：卷组是Scalable类型                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_VGMAXPVNUM_RES.out"
> $v_logfile

v_vgname=$(lsvg -o |grep -v rootvg)
for vgn in $v_vgname;do
   if [ $(lsvg $vgn |awk '/MAX PVs:/{print $NF}') -eq 1024 ];then
      :
   else
      echo "$vgn 卷组不是Scalable类型,请修改!" >> $v_logfile
   fi
done

if [ -s $v_logfile ];then
      echo "Non-Compliant"
else
      echo "Compliant"
      echo "合规" >> $v_logfile
fi

exit 0