#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_NETLINK_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 1月4  日                        #
# 功  能：检查网络状态连接数量                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_MIN_LISTEN_NUM=`grep "V_AIX_HEA_LISTEN" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`         # 端口为LISTEN状态的最小数量
v_MIN_ESTABLISH_NUM=`grep "V_AIX_HEA_ESTAB" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`      # 端口为ESTABLISHED状态的最小数量
v_MAX_CLOSE_WAIT=`grep "V_AIX_HEA_CLOSE" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`      # 端口为CLOSE_WAIT状态的最大数量
v_MAX_FIN_WAIT_2=`grep "V_AIX_HEA_FINWAIT" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt |awk -F= '{print $2}'`       #端口为FIN_WAIT_2状态的最大数量

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
echo "端口为LISTEN状态的数量为[$v_listen_num],少于[$v_MIN_LISTEN_NUM]" > SYSCHK_AIX_NETLINK_RES1.out
fi

if [ $v_establish_num -lt "$v_MIN_ESTABLISH_NUM" ]; then
v_check2=1
echo "端口为ESTABLISHED状态的数量为[$v_establish_num],少于[$v_MIN_ESTABLISH_NUM]" >> SYSCHK_AIX_NETLINK_RES1.out
fi

if [ $v_close_wait -gt "$v_MAX_CLOSE_WAIT" ]; then
v_check3=1
echo "端口为CLOSE_WAIT状态的数量为[$v_close_wait],大于[$v_MAX_CLOSE_WAIT]" >> SYSCHK_AIX_NETLINK_RES1.out
fi

if [ $v_fin_wait_2 -gt "$v_MAX_FIN_WAIT_2" ]; then
v_check4=1
echo "端口为FIN_WAIT_2状态的数量为[$v_fin_wait_2]，大于[$v_MAX_FIN_WAIT_2]" >> SYSCHK_AIX_NETLINK_RES1.out
fi

#判断是否有不正常的状态
v_total=0
v_total=`expr $v_total + $v_check1`
v_total=`expr $v_total + $v_check2`
v_total=`expr $v_total + $v_check3`
v_total=`expr $v_total + $v_check4`

if [ $v_total -ne 0 ]; then
    echo "Non-Compliant"
    mv SYSCHK_AIX_NETLINK_RES1.out SYSCHK_AIX_NETLINK_RES.out >/dev/null 2>&1
else
    echo "Compliant"
    echo "正常" > SYSCHK_AIX_NETLINK_RES.out
fi
rm -f SYSCHK_AIX_NETLINK_RES1.out >/dev/null 2>&1


exit 0;