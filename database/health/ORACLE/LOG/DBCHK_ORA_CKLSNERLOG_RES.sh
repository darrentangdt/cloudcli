#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 20120807
###是否有短连接频繁连接断开 增长1天不超过1M
###DBCHK_ORA_CKLSNERLOG_RES.sh
#############################################################

#检查临时脚本输出目录是否存在
export LANG=C
cd $log_dir >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir -p $log_dir
  cd $log_dir
fi
#设置oracle 临时输出文件
cd $log_dir/oracle >/dev/null 2>&1
if [ $? -ne 0 ]; then
    mkdir $log_dir/oracle
fi
#log_dir=$log_dir/oracle
#sh_dir=$sh_dir;
#提取阀值
v_p=`grep "V_ORA_HEA_INCREASEMB" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]]
then
    v_p=1
fi

#清空历史数据
if [ -f $log_dir/DBCHK_ORA_CKLSNERLOG_RES2.out ];then
his_val=`cat  $log_dir/DBCHK_ORA_CKLSNERLOG_RES2.out`
else
his_val=0
fi
#设置标记值
resulta=0

#查询oracle 参数$ORACLE_HOME
username=`cat $log_dir/oracount.list|awk '{print $1}'`;
su - $username -c "lsnrctl status " > $log_dir/listerlog.log

lsnr_path=`cat $log_dir/listerlog.log |grep "Listener Log File"|awk '{print $4}'`;
#lsnr_status=`cat $log_dir/listerlog.log |grep "No listener"|wc -l`
#if [ ${lsnr_status} -gt 0 ];then
#   resulta=`echo \`expr $resulta + 1\``
#   echo "数据库监听状态为[No listener]" >$log_dir/DBCHK_ORA_CKLSNERLOG_RES.out
#else
#当监听正常时
curr_val=`du -sk ${lsnr_path}|awk '{print $1}'`
increase_val=`echo \`expr ${curr_val} - ${his_val}\``
if [  $increase_val -gt $((${v_p}*1024)) ];then
    resulta=`echo \`expr $resulta + 1\``
    echo "数据库监听日志: 不正常" >$log_dir/DBCHK_ORA_CKLSNERLOG_RES.out;
	echo "listener.log 日增长量超过" $v_p "M,请确认是否有短连接频繁连接断开情况" >>$log_dir/DBCHK_ORA_CKLSNERLOG_RES.out;
else
    echo "数据库监听日志: 正常 阀值[" $v_p "M]" >$log_dir/DBCHK_ORA_CKLSNERLOG_RES.out	
fi
if [ $increase_val -lt 0 ];then
    echo "数据库监听日志发生了清理，此次检测无法正确完成" >>$log_dir/DBCHK_ORA_CKLSNERLOG_RES.out
fi
echo $curr_val  >$log_dir/DBCHK_ORA_CKLSNERLOG_RES2.out


#结果输出展示
if [[ $resulta -eq 0 ]];then
echo "Compliant"
else
echo "Non-Compliant"
fi
