#!/bin/sh
export LANG=en_US.utf8
sh_dir=/home/ap/opscloud/health_check/ORACLE
log_dir=/home/ap/opscloud/health_check/tmp
#############################################################
###Write by chenhd 20130328
###This script is a health check script of oracle database
#############################################################
#sh_dir=$sh_dir;
#log_dir=$log_dir;
mkdir -p /home/ap/healthchecklogbigsizedir;


rm -f  $log_dir/DBCHK_ORA_ARCHDIR_RES.out
resulta=0

v_p=`grep "V_ORA_HEA_ARCHDAYS" $sh_dir/ORA_HEA_PARA.txt |awk -F= '{print $2}'|head -1`;
if [[ -z $v_p ]];then
v_p=2
fi

for i in `cat -n $log_dir/oracount.list|awk '{print $1}'`
do
v_para=`cat $log_dir/oracount.list|head \`echo -$i\`|tail -1`
username=`echo $v_para|awk '{print $1}'`
sid=`echo $v_para|awk '{print $2}'`

chown $username /home/ap/healthchecklogbigsizedir;
tmp_dir=/home/ap/healthchecklogbigsizedir;

rm -f  $log_dir/DBCHK_ORA_ARCHDIR_RES3.out
rm -f  $log_dir/DBCHK_ORA_ARCHDIR_RES2.out
rm -f  $log_dir/DBCHK_ORA_ARCHDIR_RES4.out

su - $username -c "export ORACLE_SID=$sid;sh $sh_dir/sqloracle_sizelogdir.sql $v_p" > $log_dir/sizelogdir.log;
rm -f $log_dir/sizelogdir.log;

#判断ORACLE数据库版本
su - $username -c "sqlplus -v " > $tmp_dir/version.log
v_version=`cat $tmp_dir/version.log|grep -vi 'MAIL'|grep -vi 'NEW'|grep -i 'release'|awk '{print $3}'|awk -F . '{print $1}'`



su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_archlogdir" >$log_dir/DBCHK_ORA_ARCHDIR_RES2.out

realsize=`cat $tmp_dir/DBCHK_ORA_ARCHDIR_RES3.out|grep -Ev 'SQL>'`

if [ $v_version -eq 10 ];

then

su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_arch11glogdir" >$log_dir/DBCHK_ORA_ARCHDIR_RES4.out
#echo $logdir
v_status=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES4.out|grep "Automatic archival"|awk '{print $3}'`

lognum=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES2.out|grep '/'|wc -l`;


if [ $lognum -ge 1 ];
then


logdest=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES2.out|grep '/'|head -1|awk '{print $1}'`;

if [ $logdest = log_archive_dest ]
then

logdir=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES2.out|grep '/'|head -1|awk '{print $2}'`;

else

logdir=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES2.out|grep '/'|awk '{print $2}'|awk -F= '{print $2}'`;

fi
else
logdir='';
fi

else
#11g判断是否开归档
su - $username -c " export ORACLE_SID=$sid;sqlplus \"/as sysdba\" @$sh_dir/sqloracle_arch11glogdir" >$log_dir/DBCHK_ORA_ARCHDIR_RES4.out
#echo $logdir
v_status=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES4.out|grep "Automatic archival"|awk '{print $3}'`
#echo $v_status

fi

if [ $v_version -eq 10 ];
then

dirsize=0
systemtype=`uname -a |awk '{print $1}'`


if [ "$systemtype" = "HP-UX" ];then
		vcount=`bdf $logdir |wc -l`
		if [ "$vcount" -eq 3 ];then
			dirsize=`bdf $logdir |sed  '1,2d'|awk '{print $1}'`
		elif [ "$vcount" -eq 2 ];then
			dirsize=`bdf $logdir |sed  '1d'|awk '{print $2}'`
		fi
elif [ "$systemtype" = "AIX" ];then

			dirsize=`df -k $logdir|sed '1d'|awk '{print $2}'`

elif [ "$systemtype" = "Linux" ];then
		vcount=`df $logdir |wc -l`
		if [ "$vcount" -eq 3 ];then
			dirsize=`df $logdir |sed  '1,2d'|awk '{print $1}'`
		elif [ "$vcount" -eq 2 ];then
			dirsize=`df $logdir |sed  '1d'|awk '{print $2}'`
		fi
fi

else
#11G计算归档目录大小
 #echo "oracle 11g"
 su - grid -c "asmcmd lsdg" >$log_dir/DBCHK_ORA_ARCHDIR_RES5.out
 dirsize1=`cat $log_dir/DBCHK_ORA_ARCHDIR_RES5.out|grep ARCH|awk '{print $7}'`
 dirsize=`echo \`expr $dirsize1 \* 1024\``
fi


if  [[ $v_status != 'Enabled' ]]; then 
resulta=`echo \`expr $resulta + 1\``
echo "数据库实例"$sid"不正常：请开归档或者正确的设置归档路径">>$log_dir/DBCHK_ORA_ARCHDIR_RES.out

else
if [ "$realsize" -lt "$dirsize" ]; then
	#echo "Compliant"
	resulta=`echo \`expr $resulta + 0\``
	echo "数据库实例"$sid"：正常 [阀值="$v_p"天],其产生的归档大小为"`expr $realsize / 1024`"M">>$log_dir/DBCHK_ORA_ARCHDIR_RES.out

else
	#echo "Non-Compliant"
	resulta=`echo \`expr $resulta + 1\``
        echo "数据库实例"$sid"：不正常">>$log_dir/DBCHK_ORA_ARCHDIR_RES.out
	echo "目录大小不能容纳["$v_p"天]内产生的归档日志"`expr $realsize / 1024`"M">>$log_dir/DBCHK_ORA_ARCHDIR_RES.out
fi
fi
done

rm -rf  $tmp_dir
rm -f  $log_dir/DBCHK_ORA_ARCHDIR_RES2.out
if [ $resulta -eq 0 ] ;then
echo "Compliant"
else 
echo "Non-Compliant"
fi
