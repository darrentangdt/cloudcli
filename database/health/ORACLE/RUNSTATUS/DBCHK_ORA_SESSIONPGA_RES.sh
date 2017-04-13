#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 20120806
###是否单个session使用的PGA过大[默认值为100M]
###DBCHK_ORA_SESSIONPGA_RES.sh
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

v_p=`grep "V_ORA_HEA_SESSIONPGA" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;

if [[ -z $v_p ]];then
v_p=100
fi

resulta=0
> $log_dir/DBCHK_ORA_SESSIONPGA_RES.out

#设置标记值
resulta=0

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
    #tmp_dir=$log_dir/oracle;
    [ -f $log_dir/DBCHK_ORA_SESSIONPGA_RES2.out ] && rm $log_dir/DBCHK_ORA_SESSIONPGA_RES2.out
    #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid;export log_dir=$log_dir;sh $sh_dir/sqloracle_sessionpga.sql $v_p " > $logdir/log.out;
    rm $logdir/log.out

	v_count=`cat $log_dir/DBCHK_ORA_SESSIONPGA_RES2.out|grep -v SQL|grep -v NO|wc -l`
	#判断是否有大于阀值的记录输出
    if [[ $v_count -eq 0 ]];then
		     echo "数据库实例"$sid": 正常 阀值[" $v_p "M]" >>$log_dir/DBCHK_ORA_SESSIONPGA_RES.out
	 else 
		 resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_SESSIONPGA_RES.out
        echo "下列session使用的PGA大于[" $v_p "M]" >>$log_dir/DBCHK_ORA_SESSIONPGA_RES.out
        echo "[sid-serial#-PGA_ALLOC_MEM]" >>$log_dir/DBCHK_ORA_SESSIONPGA_RES.out
		cat $log_dir/DBCHK_ORA_SESSIONPGA_RES2.out|grep -v SQL|grep -v NO >> $log_dir/DBCHK_ORA_SESSIONPGA_RES.out
	 fi
done


#结果输出展示
if [[ $resulta -eq 0 ]] ;then
echo "Compliant"
else
echo "Non-Compliant"
fi
