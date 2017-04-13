#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by liuwen 2012-11-26
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthcheckparainstance;
resulta=0

rm -f $tmp_dir/DBCHK_ORA_PARAINSTANCE3.out;
rm -f $tmp_dir/DBCHK_ORA_PARAINSTANCE2.out;
rm -f $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthcheckparainstance;
tmp_dir=/home/ap/healthcheckparainstance;

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_instancegroup.sql">$log_dir/abc.log;
rm $log_dir/abc.log;
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_parainstancegroup.sql">$log_dir/abc.log;
rm $log_dir/abc.log;
#查看RAC集群的节点数
cat /home/ap/healthcheckparainstance/DBCHK_ORA_PARAINSTANCE2.out|grep -v SQL|grep -Ewvi NO|grep -v ^$|awk '{print $1}'>$tmp_dir/n.log
#按照集群的节点数来做循环
for i in `cat -n $tmp_dir/n.log|awk '{print $1}'`
do
   cat /home/ap/healthcheckparainstance/DBCHK_ORA_PARAINSTANCE2.out|grep -v ^$|grep -v SQL| grep -Ewvi NO>$tmp_dir/tmp1.out;
   cat /home/ap/healthcheckparainstance/DBCHK_ORA_PARAINSTANCE3.out|grep -v ^$|grep -v SQL| grep -Ewvi NO>$tmp_dir/tmp2.out;
   #把参数instance_name放入到V_1中
   v_1=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $1}'|sed 's/ //g'`;
   #把参数instance_name放入到V_2中
   v_2=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $2}'|sed 's/ //g'`;
   #把参数NODE_BOTH放入到V_3中
   v_3=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $3}'|sed 's/ //g'`;
   #把参数parallel_instance_group值放到V_4中
   v_4=`cat $tmp_dir/tmp2.out|head \`echo -$i\`|tail -1|awk '{print $1}'|sed 's/ //g'`;
   #echo $v_1;
   #echo $v_2;
   #echo $v_3;
   #echo $v_4;
if [[ -z $v_2 ]]
then
v_2=a
resulta=`echo \`expr $resulta + 1\``
fi
if [[ -z $v_3 ]]
then
v_3=c
resulta=`echo \`expr $resulta + 1\``
fi

if [[ $v_2 = 'node_01' && $v_3 = 'node_both' || $v_2 = 'node_02' && $v_3 = 'node_both' ]]
then
      echo '数据库实例'$v_1': 参数instance_groups正常' >> $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;

else

#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$v_1": 不正常,请查看参数instance_groups" >> $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;
#cat /home/ap/DBCHK_parainstance/DBCHK_ORA_PARAINSTANCE2.out|grep -v SQL >> $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;
fi

if [[ -z $v_4 ]]
then
v_4=d
resulta=`echo \`expr $resulta + 1\``
fi


if [[ $v_4 = 'node_01' || $v_4 = 'node_02' ]]
  then
          echo '数据库实例'$v_1': 参数parallel_instance_group正常' >> $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;
  else
          resulta=`echo \`expr $resulta + 1\``
          echo "数据库实例"$v_1": 不正常,请查看参数parallel_instance_group" >> $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;
          #cat /home/ap/DBCHK_parainstance/DBCHK_ORA_PARAINSTANCE3.out|grep -v SQL >> $log_dir/DBCHK_ORA_PARAINSTANCE_RES.out;
fi


done
done
rm -rf $tmp_dir;



if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi
exit 0;