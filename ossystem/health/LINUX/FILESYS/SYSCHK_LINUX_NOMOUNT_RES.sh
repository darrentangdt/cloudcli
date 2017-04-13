#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_NOMOUNT_RES.sh            #
# 作  者：CCSD_liyu                            #
# 日  期：2013年03月06日                        #
# 功  能：检查没有mount上的文件系统              #
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

logfile="SYSCHK_LINUX_NOMOUNT_RES.out"
> $logfile

v_ignore_fs=$(awk -F= '/V_LIN_HEA_IGNORE_FS=/{print $2}' $sh_dir/LINUX_HEA_PARA.txt)

v_num_1=`mount |grep -Evi "^none|sunrpc|$v_ignore_fs"|awk '{print $3}'|wc -l`
v_num_2=`grep -Evi "swap|^$|^#" /etc/fstab |awk '{print $2}' |wc -l`

if [ $v_num_1 -eq $v_num_2 ]; then
echo "Compliant"
echo "正常" > $logfile
echo "mount命令显示如下:" >> $logfile
mount >> $logfile
exit 0
fi

v_mount=`mount |grep -Evi "^none|sunrpc" |awk '{print $3}'`
v_fstab=`grep -Evi "swap|^$|^#" /etc/fstab |awk '{print $2}'`

if  [ $v_num_2 -gt $v_num_1 ];then
echo "Non-Compliant"
for v_fstab_1 in $v_fstab ;do
     echo "$v_mount" | grep "$v_fstab_1" > /dev/null 
	 if [ $? -ne 0 ];then
	    echo "/etc/fstab中文件系统[$v_fstab_1]没有挂载到系统中" >> $logfile
     fi
done
fi

if  [ $v_num_2 -lt $v_num_1 ];then
echo "Non-Compliant"
for v_mount_1 in $v_mount ;do
     echo "$v_fstab" | grep "$v_mount_1" > /dev/null 
	 if [ $? -ne 0 ];then
	    echo "mount命令输出中,文件系统[$v_mount_1]挂载到系统中,但没写入到fstab中" >> $logfile
     fi
done
fi

echo "please check filesystem"
mount  >> $logfile
grep -v "^#" /etc/fstab  >> $logfile

exit 0