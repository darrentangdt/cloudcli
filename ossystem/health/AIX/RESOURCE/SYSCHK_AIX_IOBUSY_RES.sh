#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_IOBUSY_RES.sh               #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查系统磁盘是否繁忙                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_p1=`grep "V_AIX_HEA_IOWAIT" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_p2=`grep "V_AIX_HEA_TMACT" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
v_iowait=`iostat |sed -n '/iowait/{n;p;}' |awk '{print $6}'`
v_busynum=`iostat -d |sed -n '/Disks:/,$p' |sed '1d' |awk '($2>'"$v_p2"') {print $0}' |wc -l`

if [ $v_iowait -gt $v_p1 ]; then
echo "当前cpu的iowait百分比为[$v_iowait]%,大于阀值[$v_p1]" >SYSCHK_AIX_IOBUSY_RES1.out
fi

if [ $v_busynum -gt $v_p2 ]; then
echo "当前存在磁盘利用率大于阀值[$v_p2]的磁盘" >> SYSCHK_AIX_IOBUSY_RES1.out
iostat -d >> SYSCHK_AIX_IOBUSY_RES1.out
fi

if [ -s SYSCHK_AIX_IOBUSY_RES1.out ]; then
   echo "Non-Compliant"
   mv SYSCHK_AIX_IOBUSY_RES1.out SYSCHK_AIX_IOBUSY_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_IOBUSY_RES.out
   echo "iostat 命令显示如下:">> SYSCHK_AIX_IOBUSY_RES.out
   iostat >> SYSCHK_AIX_IOBUSY_RES.out
   echo "iostat -d 命令显示结果如下:" >> SYSCHK_AIX_IOBUSY_RES.out
   iostat -d >> SYSCHK_AIX_IOBUSY_RES.out
fi
rm -f SYSCHK_AIX_IOBUSY_RES1.out >/dev/null 2>&1

exit 0;