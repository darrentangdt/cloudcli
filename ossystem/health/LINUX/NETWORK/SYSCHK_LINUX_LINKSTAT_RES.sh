#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_LINKSTAT_RES.sh           #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查网络连接状态                       #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/health_check/LINUX"
log_dir="/home/ap/opscloud/logs"
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi

v_MIN_LISTEN_NUM=`grep "V_LIN_HEA_LIS" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`         # 端口为LISTEN状态的最小数量
v_MIN_ESTABLISH_NUM=`grep "V_LIN_HEA_ESTAB" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`    # 端口为ESTABLISHED状态的最小数量
v_MAX_CLOSE_WAIT=`grep "V_LIN_HEA_CLOSWAIT" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`  # 端口为CLOSE_WAIT状态的最大数量
v_MAX_FIN_WAIT_2=`grep "V_LIN_HEA_FINWAINT" $sh_dir/LINUX_HEA_PARA.txt |awk -F= '{print $2}'`  #端口为FIN_WAIT_2状态的最大数量

v_check1=0
v_check2=0
v_check3=0
v_check4=0

v_listen_num=`netstat -an|grep "^tcp" |awk '{print $6}'|sort -ir|uniq -c |grep LISTEN |awk '{print $1}'`
v_establish_num=`netstat -an|grep "^tcp" |awk '{print $6}'|sort -ir|uniq -c |grep ESTABLISHED |awk '{print $1}'`
v_close_wait=`netstat -an|grep "^tcp" |awk '{print $6}'|sort -ir|uniq -c |grep CLOSE_WAIT |awk '{print $1}'`
v_fin_wait_2=`netstat -an|grep "^tcp" |awk '{print $6}'|sort -ir|uniq -c |grep FIN_WAIT_2 |awk '{print $1}'`

if [ -z "$v_listen_num" ]; then
v_listen_num=0
fi

if [ -z "$v_establish_num" ]; then
v_establish_num=0
fi

if [ -z "$v_close_wait" ]; then
v_close_wait=0
fi

if [ -z "$v_fin_wait_2" ]; then
v_fin_wait_2=0
fi

#比较网状各种状态的实际数量与设定值的关系
if [ $v_listen_num -lt "$v_MIN_LISTEN_NUM" ]; then
v_check1=1
echo "当前端口为LISTEN状态的数量为[$v_listen_num],少于[$v_MIN_LISTEN_NUM]" > SYSCHK_LINUX_LINKSTAT_RES1.out
fi

if [ $v_establish_num -lt "$v_MIN_ESTABLISH_NUM" ]; then
v_check2=1
echo "当前端口为ESTABLISHED状态的数量为[$v_establish_num],少于[$v_MIN_ESTABLISH_NUM]" >> SYSCHK_LINUX_LINKSTAT_RES1.out
fi

if [ $v_close_wait -gt "$v_MAX_CLOSE_WAIT" ]; then
v_check3=1
echo "当前端口为CLOSE_WAIT状态的数量为[$v_close_wait],大于[$v_MAX_CLOSE_WAIT]" >> SYSCHK_LINUX_LINKSTAT_RES1.out
fi

if [ $v_fin_wait_2 -gt "$v_MAX_FIN_WAIT_2" ]; then
v_check4=1
echo "当前端口为FIN_WAIT_2状态的数量为[$v_fin_wait_2],大于[$v_MAX_FIN_WAIT_2]" >> SYSCHK_LINUX_LINKSTAT_RES1.out
fi

#判断是否有不正常的状态
v_total=0
v_total=`expr $v_total + $v_check1`
v_total=`expr $v_total + $v_check2`
v_total=`expr $v_total + $v_check3`
v_total=`expr $v_total + $v_check4`

if [ $v_total -ne 0 ]; then
    echo "Non-Compliant"
    cat SYSCHK_LINUX_LINKSTAT_RES1.out > SYSCHK_LINUX_LINKSTAT_RES.out
    rm SYSCHK_LINUX_LINKSTAT_RES1.out
else
    echo "Compliant"
    echo "正常" > SYSCHK_LINUX_LINKSTAT_RES.out
fi

exit 0;