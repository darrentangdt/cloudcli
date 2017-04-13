#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-11-26
###This script is a compliant check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/audit_asmcheckgroup;

#删除上次执行的结果
rm -f $log_dir/DBAUD_ORA_ASMCHECKGROUP_RES.out

#设置标志位为0
resulta=0

#创建临时目录
mkdir -p /home/ap/audit_asmcheckgroup;
tmp_dir=/home/ap/audit_asmcheckgroup;
chown oracle /home/ap/audit_asmcheckgroup;

#获取ORACLE_HOME目录的所属组和用户
su - grid -c "env" >/home/ap/audit_asmcheckgroup/asmcheckgroup.out
abc=`cat /home/ap/audit_asmcheckgroup/asmcheckgroup.out |grep -Ewi ORACLE_HOME= |awk -F = '{print $2}'`
v_owner=`ls -l ${abc}/bin/crsctl|awk '{print $3}'`
v_group=`ls -l ${abc}/bin/crsctl|awk '{print $4}'`



#如果GRID_HOME所属用户不为grid和所属组不为oinstall则不合规
if [[ $v_owner = grid && $v_group = oinstall ]];then
echo  "GRID_HOME所属组所属用户合规">>$log_dir/DBAUD_ORA_ASMCHECKGROUP_RES.out
else
resulta=`echo \`expr $resulta + 1\``
echo "GRID_HOME所属组所属用户不合规，请查看" >> $log_dir/DBAUD_ORA_ASMCHECKGROUP_RES.out;
fi

#done
rm -rf $tmp_dir;

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
