#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20091104
###This script is a compliant check script of oracle database
###edit by ycl 20120730
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
  mkdir -p $log_dir/oracle
  cd $log_dir/oracle
fi

#log_dir=$log_dir/oracle

> $log_dir/DBCHK_ORA_CURSORCHK_RES.out


#提取默认阀值
v_p=`grep -Ew "V_ORA_HEA_CURSOR" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`
if [[ -z $v_p ]];then
	v_p=70
fi

#定义flag
resulta=0



#实例循环检查
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
    v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
    username=`echo $v_para|awk '{print $1}'`
    sid=`echo $v_para|awk '{print $2}'`

		#更改目录权限
		chown $username $log_dir
        rm $log_dir/DBCHK_ORA_CURSORCHK_RES2.out
        #su 到oracle用户下执行sql
		su - $username -c " export ORACLE_SID=$sid; sh $sh_dir/sqloracle_cursor_check.sql $v_p" > /tmp/pga.log;
        rm /tmp/pga.log;
    

		sidcomp=`cat $log_dir/DBCHK_ORA_CURSORCHK_RES2.out|grep -v SQL|grep -v no|wc -l`
		v_limited=`cat $log_dir/DBCHK_ORA_CURSORCHK_RES2.out|grep -v SQL|grep -v no|awk '{print $2}'|head -1`
		if [[ -z $v_limited ]];then
		v_limited=0
		fi
		if [ $sidcomp -gt 0 -a $v_limited -lt 200 ];then
		      resulta=`echo \`expr $resulta + 1\``
              echo "数据库实例"$sid": 不正常" >>$log_dir/DBCHK_ORA_CURSORCHK_RES.out;
              echo "游标使用率超过["$v_p"%],且limited_cursor小于200的session有"$sidcomp"个">>$log_dir/DBCHK_ORA_CURSORCHK_RES.out;
		else
		      echo "数据库实例"$sid": 正常 [阀值="$v_p"%]">>$log_dir/DBCHK_ORA_CURSORCHK_RES.out
    fi
done

if [ $resulta -eq 0 ];then
		echo "Compliant"
else 
		echo "Non-Compliant"
fi
