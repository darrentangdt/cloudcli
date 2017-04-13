#!/bin/sh
export LANG=en_US.utf8
. `find . -name aud_ora_parameter.cfg`
#############################################################
###Write by liuwen 2012-11-26
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/dbaud_parainstance;
resulta=0
rm -f $tmp_dir/DBAUD_ORA_PARAINSTANCE3.out;
rm -f $tmp_dir/DBAUD_ORA_PARAINSTANCE2.out;
rm -f $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;
chown $username /home/ap/dbaud_parainstance;
tmp_dir=/home/ap/dbaud_parainstance;
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_instancegroup.sql">$log_dir/abc.log;
rm $log_dir/abc.log;
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_parainstancegroup.sql">$log_dir/abc.log;
rm $log_dir/abc.log;
#查看RAC集群的节点数
cat /home/ap/dbaud_parainstance/DBAUD_ORA_PARAINSTANCE2.out|grep -v SQL|grep -Ewvi NO|grep -v ^$|awk '{print $1}'>$tmp_dir/n.log
#按照集群的节点数来做循环
for i in `cat -n $tmp_dir/n.log|awk '{print $1}'`
do
   cat /home/ap/dbaud_parainstance/DBAUD_ORA_PARAINSTANCE2.out|grep -v ^$|grep -v SQL| grep -Ewvi NO>$tmp_dir/tmp1.out;
   cat /home/ap/dbaud_parainstance/DBAUD_ORA_PARAINSTANCE3.out|grep -v ^$|grep -v SQL| grep -Ewvi NO>$tmp_dir/tmp2.out;
   #把参数instance_name放入到V_1中
   v_1=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $1}'|sed 's/ //g'`;
   #把参数instance_name放入到V_2中
   v_2=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $2}'|sed 's/ //g'`;
   #把参数NODE_BOTH放入到V_3中
   v_3=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $3}'|sed 's/ //g'`;
   #把参数parallel_instance_group值放到V_4中
   v_4=`cat $tmp_dir/tmp2.out|head \`echo -$i\`|tail -1|awk '{print $1}'|sed 's/ //g'`;
   v_5=`cat $tmp_dir/tmp1.out|head \`echo -$i\`|tail -1|awk -F , '{print $4}'|sed 's/ //g'`;
   #echo $v_1;
   #echo $v_2;
   #echo $v_3;
if [[ $v_2 = $v_1 && $v_3 = 'node_both' || $v_2 = $v_5 && $v_3 = 'node_both' ]]
then
      echo '数据库实例'$v_5': 参数instance_groups['$v_2','$v_3']合规' >> $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
else
#echo "Non-Compliant";
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$v_5": 不合规,instance_groups["$v_2","$v_3"]命名不合规" >> $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
#cat /home/ap/dbaud_parainstance/DBAUD_ORA_PARAINSTANCE2.out|grep -v SQL >> $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
fi
if [[ -z $v_4 ]]
then
v_4=d
resulta=`echo \`expr $resulta + 1\``
fi
if [[ $v_2 = $v_4 ]]
  then
          echo '数据库实例'$v_5': 参数parallel_instance_group合规' >> $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
  else
          resulta=`echo \`expr $resulta + 1\``
          echo "数据库实例"$v_5": parallel_instance_group[$v_4]参数不合规" >> $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
          #cat /home/ap/dbaud_parainstance/DBAUD_ORA_PARAINSTANCE3.out|grep -v SQL >> $log_dir/DBAUD_ORA_PARAINSTANCE_RES.out;
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
