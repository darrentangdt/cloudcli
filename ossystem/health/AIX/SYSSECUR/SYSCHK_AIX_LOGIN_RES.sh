#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_LOGIN_RES.sh                #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4 日                         #
# 功  能：判断当前用户连接数                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#判断当前用户连接数
v_lognum=`who |wc -l`
v_p1=`grep "V_AIX_HEA_LINKNUM" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_lognum -gt "$v_p1" ]; then
   echo "Non-Compliant"
   echo "当前登录到主机的用户数为[$v_lognum]" > SYSCHK_AIX_LOGIN_RES.out
   else
   echo "Compliant"
   echo "正常" > SYSCHK_AIX_LOGIN_RES.out
   echo "w 命令显示结果为:" >> SYSCHK_AIX_LOGIN_RES.out
   w >> SYSCHK_AIX_LOGIN_RES.out
fi


exit 0;