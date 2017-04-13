#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_MIRROR_MWC_RES.sh           #
# 作  者：CCSD_CL                                #
# 日  期：2013年 5月13日                         #
# 功  能：检查镜像VG中是并发卷组的MWC参数是否关闭#
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

>SYSAUD_AIX_MIRROR_MWC_RES.out

#检查非rootvg是否做了镜像
vg_name_on=$(lsvg -o |grep -Ev "rootvg")
if [ -z "$vg_name" ];then
echo "没有非rootvg" >> SYSAUD_AIX_MIRROR_MWC_RES.out
echo "Log"
exit 0
fi
for vg_name in $vg_name_on;do
v_mirr=`lsvg -l $vg_name | grep -Ev "$vg_name|LV NAME"|awk '{print $4/$3}'|grep -c 2`
if [ $v_mirr = 0 ]; then
echo "Compliant"
echo "$vg_name 未配置镜像，不做后续判断" >> SYSAUD_AIX_MIRROR_MWC_RES.out
 else
 v_concurrent=`lsvg $vg_name |grep "Concurrent:"|awk '{print $2}'|grep -c "Enhanced-Capable"`
 if [ $v_concurrent = 0 ] ;then
  echo "Compliant"
  echo "$vg_name 未配置为并发卷组，不做后续判断" >> SYSAUD_AIX_MIRROR_MWC_RES.out
else
  echo "$vg_name 已配置为并发卷组，后续判断MWC是否关闭" >> SYSAUD_AIX_MIRROR_MWC_RES.out
lv_name_on=$(lsvg -l $vg_name | grep -Ev "$vg_name|LV NAME"|awk '{print $1}')
for lv_name in $lv_name_on;do
v_mwc=`lslv $lv_name|grep "MIRROR WRITE CONSISTENCY:"|awk '{print $4}'|grep -c off`
if [ $v_mwc = 1 ];then
     echo "Compliant"
     echo "$lv_name 合规，MWC参数已配置为off" >> SYSAUD_AIX_MIRROR_MWC_RES.out
     else
     echo "Non-Compliant"
     echo "$lv_name 做了镜像并且是并发卷组，如属于多节点读写，MWC参数需配置为off" >> SYSAUD_AIX_MIRROR_MWC_RES.out
    fi
done
fi
fi
done
exit 0
