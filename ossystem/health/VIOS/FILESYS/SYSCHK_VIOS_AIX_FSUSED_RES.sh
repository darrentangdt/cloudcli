#!/bin/sh
#************************************************#
# 文件名:SYSCHK_VIOS_AIX_FSUSED_RES.sh
# 作  者:CCSD_LIYU
# 日  期:2012年 12月25日
# 功  能:检查文件系统利用率
# 复核人:
#************************************************#

#判断该台主机是不是VIOS
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		:
	else
exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

#参数文件位置
v_parameter_file="/home/ap/opscloud/health_check/VIOS/AIX_HEA_PARA.txt"

#日志文件输出名字
v_logfile="SYSCHK_VIOS_AIX_FSUSED_RES.out"
> $v_logfile

#mount point和相关使用率百分比大小
v_mount_point_and_rate=$(df|awk '{if($(NF-3) == "-"){}else{print $NF"-"$(NF-3)}}'|grep "^/"|sed 's/%//g')

#用户定义的通用检阈值
lv_used_limit_all=$(awk -F= '/V_AIX_HEA_FSUSEM/{print $NF}' $v_parameter_file)
[ -z "$lv_used_limit_all" ] && lv_used_limit_all="80"

#循环判断是否超过阈值 lv_used_limit_all
for v_mount_point in $v_mount_point_and_rate;do
    v_mount=$(echo $v_mount_point |awk -F- '{print $(NF-1)}')
    v_user_limit_rate=$(grep "^$v_mount=" $v_parameter_file| awk -F= '{print $NF}')
	[ -z "$v_user_limit_rate" ] && v_user_limit_rate=$(echo $lv_used_limit_all)
	v_rate=$(echo $v_mount_point |awk -F- '{print $NF}')
	if [ $v_rate -gt $v_user_limit_rate ];then
		echo "$v_mount is  $v_rate " >> $v_logfile
	fi
done

#mount point和相关inode使用率百分比大小
v_mount_point_and_inode_rate=$(df|awk '{if($(NF-3) == "-"){}else{print $NF"-"$(NF-1)}}'|grep "^/"|sed 's/%//g')

#用户定义的通用检阈值
lv_used_inode_all=$(awk -F= '/V_AIX_HEA_FSIUSEM/{print $NF}' $v_parameter_file)
[ -z "$lv_used_inode_all" ] && lv_used_inode_all="70"

#循环判断是否超过阈值 lv_used_inode_all
for v_inode_point in $v_mount_point_and_inode_rate;do
    v_inode=$(echo $v_inode_point |awk -F- '{print $(NF-1)}')
    v_user_inode_rate=$(grep "^$v_inode-inode=" $v_parameter_file| awk -F= '{print $NF}')
	[ -z "$v_user_inode_rate" ] && v_user_inode_rate=$(echo $lv_used_inode_all)
	v_rate=$(echo $v_inode_point |awk -F- '{print $NF}')
	if [ $v_rate -gt $v_user_inode_rate ];then
		echo "$v_inode inode is $v_rate  " >> $v_logfile
	fi
done

#判断文件是否存在并且字节数大于0(如果大于0说明有错误信息存入文件为不合规)
if [ -s "$v_logfile" ];then
    echo "Non-Compliant"
	echo "异常, 文件系统使用率超出阈值, 请检查" >>$v_logfile
else
    echo "Compliant"
	echo "正常" >> $v_logfile
	df >> $v_logfile
fi

exit 0