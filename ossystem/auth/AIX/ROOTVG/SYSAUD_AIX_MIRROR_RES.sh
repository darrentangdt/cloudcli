#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_MIRROR_RES.sh               #
# 作  者：CCSD_CL                                #
# 日  期：2013年 5月13日                         #
# 功  能：检查镜像VG中QUORUM是否关闭             #
# 复核人：                                       #
#************************************************#
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi

>SYSAUD_AIX_MIRROR_RES.out

#检查是否做了镜像
vg_name_on=$(lsvg)
for vg_name in $vg_name_on;do
v_mirr=`lsvg -l $vg_name | grep -Ev "$vg_name|LV NAME"|awk '{print $4/$3}'|grep -c 2`
if [ $v_mirr = 0 ]; then
echo "Compliant"
echo "$vg_name 未配置镜像，不做后续判断" >> SYSAUD_AIX_MIRROR_RES.out
 else
 v_quorum=`lsvg $vg_name |grep QUORUM |awk '{print $6}'`
 if [ $v_quorum = "(Disabled)" ] ;then
  echo "Compliant"
  echo "合规" >> SYSAUD_AIX_MIRROR_RES.out
  else
     echo "Non-Compliant"
     echo "$vg_name 配置了镜像但QUORUM未置为Disabled!" >> SYSAUD_AIX_MIRROR_RES.out
fi
fi
done
exit 0

