#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_KERDEBUG_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查系统运行缺省的内核debug 选项       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_bosdeg=`bosdebug |grep "Kernel debugger" |awk '{print $3}'`

if [ $v_bosdeg != "off" ]
then
echo "Non-Compliant"
echo "系统目前Kernel debugger项为on,建议Kernel debugger项为off" > SYSAUD_AIX_KERDEBUG_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_KERDEBUG_RES.out
fi