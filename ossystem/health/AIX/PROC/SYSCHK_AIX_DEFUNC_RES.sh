#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_DEFUNC_RES.sh               #
# 作  者：CCSD_liyu                            #
# 日  期：2012年4月5日                        #
# 功  能：检查僵尸进程数量                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#用户可以同事列出多个用户类似grep -E功能"grep -E "ctem|root" 方法来列出多个用户
v_UID=`grep "V_AIX_HEA_FUNOWN" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
[ -z "$v_UID" ] && v_UID="zsefvbjil_nju wclw"
v_def=`ps -ef| grep "defunc" | grep -v "grep" | grep -Ev "$v_UID" |wc -l`
v_p1=`grep "V_AIX_HEA_FUNCNUM" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`
if [ $v_def -gt "$v_p1" ]
then
echo "Non-Compliant"
echo "系统存在以下僵尸进程" > SYSCHK_AIX_DEFUNC_RES.out
ps -ef | grep "defunc" | grep -v "grep" | grep -Ev "$v_UID" >> SYSCHK_AIX_DEFUNC_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_AIX_DEFUNC_RES.out
echo "ps -ef| grep "defunc" | grep -v "grep" 命令显示结果为:" >> SYSCHK_AIX_DEFUNC_RES.out
ps -ef| grep "defunc" | grep -v "grep" >> SYSCHK_AIX_DEFUNC_RES.out
fi

exit 0;