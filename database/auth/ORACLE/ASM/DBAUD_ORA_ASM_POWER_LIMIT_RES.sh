#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-11-26
###This script is a compliant check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/audit_asm_power_limit;

#删除上次执行的结果
rm -f $log_dir/DBAUD_ORA_ASM_POWER_LIMIT_RES.out
rm -f $tmp_dir/DBAUD_ORA_ASM_POWER_LIMIT_RES1.out;

#设置标志位为0
resulta=0

#循环机器上所有的数据库
#for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
#do
#v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
#获取用户名
username='grid'
#获取SID
#sid=`echo $v_para|awk '{print $2}'`

chown $username /home/ap/audit_asm_power_limit;
tmp_dir=/home/ap/audit_asm_power_limit;

#执行SQL语句
su - $username -c "sh $sh_dir/sqloracle_asm_power_limit.sql">$log_dir/abc.log;
rm $log_dir/abc.log;

#把执行后的结果放到ASMASM_POWER_LIMIT中
asmASM_POWER_LIMIT=`cat $tmp_dir/DBAUD_ORA_ASM_POWER_LIMIT1.out|grep -Ewvi no|grep -Ewvi sql |grep -v ^$|awk '{print $1}'`

#如果ASM_POWER_LIMIT不等于1则不合规
if [[ $asmASM_POWER_LIMIT != 1 ]];then
#echo "Non-Compliant"
resulta=`echo \`expr $resulta + 1\``
echo "ASM_POWER_LIMIT不合规，当前值为:"$asmASM_POWER_LIMIT >> $log_dir/DBAUD_ORA_ASM_POWER_LIMIT_RES.out;
echo "合规值为1" >> $log_dir/DBAUD_ORA_ASM_POWER_LIMIT_RES.out;
else

echo  "ASM_ASM_POWER_LIMITS合规">>$log_dir/DBAUD_ORA_ASM_POWER_LIMIT_RES.out
fi

#done
rm -rf $tmp_dir;

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
