#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by YCL 20130831
###CHECK RAC +ASM FILESYSTEM 
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
resulta=0

data_num=`/home/db/grid/product/11.2.0/bin/ocrcheck |grep '+DATA'|wc -l`
arch_num=`/home/db/grid/product/11.2.0/bin/ocrcheck |grep '+ARCH'|wc -l`
let v_num=data_num+arch_num

if [ $v_num -eq 2 ]
then
  echo '数据库实例'$sid': 正常' > $log_dir/DBAUD_ORA_OCRCHECK_RES.out;
else
#echo "Compliant";
  let resulta=resulta+1
  echo '数据库实例'$sid': 不正常' > $log_dir/DBAUD_ORA_OCRCHECK_RES.out;
  /home/db/grid/product/11.2.0/bin/ocrcheck >> $log_dir/DBAUD_ORA_OCRCHECK_RES.out;
fi

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
#echo $?
