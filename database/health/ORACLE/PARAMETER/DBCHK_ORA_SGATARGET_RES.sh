#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 20120807
###设置了SGA_TARGET该参数使数据库自行调整各部件内存分配，
###容易触发bug
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
v_p=`grep "V_ORA_HEA_SGATARGET" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;

if [[ -z $v_p ]]
then
    v_p=0
fi

#清空历史数据
> $log_dir/DBCHK_ORA_SGATARGET_RES.out

#设置标记值
resulta=0

#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
	v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
	username=`echo $v_para|awk '{print $1}'`
	sid=`echo $v_para|awk '{print $2}'`


	#更改目录权限
	chown $username $log_dir/oracle;
  #su 到oracle用户下执行sql
	su - $username -c "export ORACLE_SID=$sid; sh $sh_dir/sqloracle_sgatarget.sql " > $log_dir/out.log;
  rm $log_dir/out.log

	v_sgatarget=`cat $log_dir/DBCHK_ORA_SGATARGET_RES2.out|grep -Ev 'SQL|no|^$'|sed 's/ //g'`
        rm $log_dir/DBCHK_ORA_SGATARGET_RES2.out
	#判断是否有大于阀值的记录输出
  if [[ $v_sgatarget -eq $v_p ]];then
		echo "数据库实例"$sid": 正常 阀值[" $v_p "]" >>$log_dir/DBCHK_ORA_SGATARGET_RES.out
	else 
		resulta=`echo \`expr $resulta + 1\``
    echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_SGATARGET_RES.out
    echo "SGA_TARGET参数为"$v_sgatarget,"规范不推荐设置该值" >>$log_dir/DBCHK_ORA_SGATARGET_RES.out
	 fi
done


#结果输出展示
if [[ $resulta -eq 0 ]];then
echo "Compliant"
else
echo "Non-Compliant"
fi
