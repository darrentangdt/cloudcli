#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
################################################################
###Write by liuwen 2012.8.7
### Modify by liuwen 2013.3.7
###This script is a health check script of oracle database
################################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthcheckforeignindex;
resulta=0
rm -f $log_dir/DBCHK_ORA_FOREIGNINDEX_RES.out;
rm -f $tmp_dir/DBCHK_ORA_FOREIGNINDEX_RES2.out;
v_p=`grep "V_ORA_HEA_FORTABLE" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'`;
if [[ -z $v_p ]];then
v_p="&"
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`;

chown $username /home/ap/healthcheckforeignindex;
tmp_dir=/home/ap/healthcheckforeignindex;

rm -f $tmp_dir/DBCHK_ORA_FOREIGNINDEX2.out
su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_foreignindex.sql">$log_dir/abc.log;
rm $log_dir/abc.log;
rm -f $log_dir/DBCHK_ORA_FOREIGNINDEX3.out

#echo "--OWNER,TABLE_NAME,CONSTRAINT_NAME--" >>$log_dir/DBCHK_ORA_FOREIGNINDEX3.out;
for name in `cat $tmp_dir/DBCHK_ORA_FOREIGNINDEX2.out|grep -v SQL|grep -v NO`
do
v_table_name=`echo $name|awk -F "," '{print $2}'`
v_count=`echo $v_p|grep -iw $v_table_name|wc -l`;

if [ "$v_count" -eq  0 ];then
#echo "Compliant"
   echo $name >>$log_dir/DBCHK_ORA_FOREIGNINDEX3.out;
fi
done

if [ -f $log_dir/DBCHK_ORA_FOREIGNINDEX3.out ];then

    v_num=`cat $log_dir/DBCHK_ORA_FOREIGNINDEX3.out|wc -l`;

    if [ $v_num -gt 0 ];then
        resulta=`echo \`expr $resulta + 1\``;
        echo $sid"不正常以下表外键没有索引" >> $log_dir/DBCHK_ORA_FOREIGNINDEX_RES.out;
        cat $log_dir/DBCHK_ORA_FOREIGNINDEX3.out|grep -v SQL|grep -v ^$ >> $log_dir/DBCHK_ORA_FOREIGNINDEX_RES.out;
    else
        echo '数据库实例'$sid':正常' >> $log_dir/DBCHK_ORA_FOREIGNINDEX_RES.out;
    fi
else
    echo "数据库实例"$sid":正常" >> $log_dir/DBCHK_ORA_FOREIGNINDEX_RES.out;
fi
done
rm -rf $tmp_dir;

if [ $resulta -ne 0 ]
then
echo "Non-Compliant";
else
echo "Compliant";
fi

exit 0;