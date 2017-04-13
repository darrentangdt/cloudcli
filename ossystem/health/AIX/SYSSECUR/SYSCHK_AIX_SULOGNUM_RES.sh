#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_SULOGNUM_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：检查系统用户su操作次数                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#检查当天su的次数是否超过规定次数
if [ -f /var/adm/sulog ]; then
v_date=`date +%m/%d`
v_p1=`grep "V_AIX_HEA_SULOGNUM" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
tail -100 /var/adm/sulog |grep "$v_date" |awk '{print $2}' |uniq -c |awk  '( $1 > '"$v_p1"' ) {print $0}' > SYSCHK_AIX_SULOGNUM_RES.out
if [ -s SYSCHK_AIX_SULOGNUM_RES.out ]; then
   echo "Non-Compliant"
   echo "今日有用户进行[$v_p1]次以上su操作" > SYSCHK_AIX_SULOGNUM_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_SULOGNUM_RES.out
fi
else
   echo "Non-Compliant"
   echo "系统文件/var/adm/sulog不存在" > SYSCHK_AIX_SULOGNUM_RES.out
fi


exit 0;