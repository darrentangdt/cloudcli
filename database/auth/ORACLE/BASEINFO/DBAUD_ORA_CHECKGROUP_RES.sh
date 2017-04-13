#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-11-26
###This script is a compliant check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/audit_checkgroup;

#删除上次执行的结果
rm -f $log_dir/DBAUD_ORA_CHECKGROUP_RES.out
#rm -f $tmp_dir/DBAUD_ORA_CHECKGROUP_RES1.out

#设置标志位为0
resulta=0

#创建临时目录
mkdir -p /home/ap/audit_checkgroup;
tmp_dir=/home/ap/audit_checkgroup;
chown oracle /home/ap/audit_checkgroup;

#获取ORACLE_HOME目录的所属组和用户
su - oracle -c "env" >/home/ap/audit_checkgroup/checkgroup.out
abc=`cat /home/ap/audit_checkgroup/checkgroup.out |grep -Ewi ORACLE_HOME= |awk -F = '{print $2}'`
v_owner=`ls -l ${abc}/bin/oracle|awk '{print $3}'`
v_group=`ls -l ${abc}/bin/oracle|awk '{print $4}'`


#如果ORACLE_HOME所属用户不为ORACLE和所属组不为oinstall则不合规
if [[ $v_owner = oracle && $v_group = oinstall ]];then
echo  "ORACLE_HOME所属组所属用户合规">>$log_dir/DBAUD_ORA_CHECKGROUP_RES.out
else
resulta=`echo \`expr $resulta + 1\``
echo "ORACLE_HOME所属组为"$v_owner,$v_group",所属用户不合规" >> $log_dir/DBAUD_ORA_CHECKGROUP_RES.out;
fi

rm -rf $tmp_dir;

if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
