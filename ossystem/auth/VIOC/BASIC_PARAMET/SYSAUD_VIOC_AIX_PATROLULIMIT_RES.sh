#!/bin/sh
#************************************************#
# 文件名:SYSAUD_VIOC_AIX_PATROLULIMIT_RES.sh
# 作  者:iomp_zcw
# 日  期:2014年2月10日
# 功  能:检查PATROL用户的ulimit设置情况
#
#************************************************#

#判断该台主机是不是VIOC
export LANG=ZH_CN.UTF-8
if grep padmin /etc/passwd >/dev/null 2>&1
	then
		exit 0
fi

#检查临时脚本输出目录是否存在
cd /home/ap/opscloud/logs >/dev/null 2>&1||mkdir -p /home/ap/opscloud/logs
cd /home/ap/opscloud/logs >/dev/null 2>&1

logfile="SYSAUD_VIOC_AIX_PATROLULIMIT_RES.out"
> $logfile

id patrol >/dev/null 2>&1
if [ $? -ne 0 ];then
	echo "Non-Compliant"
	echo "patrol 用户不存在" >> $logfile
  exit 0
fi
v_data_min=948576
v_data_max=1148576
v_stack_min=514288
v_stack_max=534288
v_rss_min=514288
v_rss_max=534288
v_fsize_min=4194304
v_fsize_max=4200000
v_nofile_min=4096
v_nofile_max=8192

#data
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^data/{ {if ($NF > '"$v_data_min"' && $NF < '"$v_data_max"'){ print "data:"$NF",OK;" }
                               else if ($NF <= '"$v_data_min"'){ print "data:"$NF",LOW;" }
                             else if ($NF > '"$v_data_max"'){ print "data:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#stack
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^stack/{ {if ($NF > '"$v_stack_min"' && $NF < '"$v_stack_max"'){ print "stack:"$NF",OK;" }
                               else if ($NF <= '"$v_stack_min"'){ print "stack:"$NF",LOW;" }
                             else if ($NF > '"$v_stack_max"'){ print "stack:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#memory
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^memory/{ {if ($NF > '"$v_rss_min"' && $NF < '"$v_rss_max"'){ print "memory:"$NF",OK;" }
                               else if ($NF <= '"$v_rss_min"'){ print "memory:"$NF",LOW;" }
                             else if ($NF > '"$v_rss_max"'){ print "memory:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#file
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^file/{ {if ($NF > '"$v_fsize_min"' && $NF < '"$v_fsize_max"'){ print "file:"$NF",OK;" }
                               else if ($NF <= '"$v_fsize_min"'){ print "file:"$NF",LOW;" }
                             else if ($NF > '"$v_fsize_max"'){ print "file:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#nofile
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^nofiles/{ {if ($NF > '"$v_nofile_min"' && $NF < '"$v_nofile_max"'){ print "nofiles:"$NF",OK;" }
                               else if ($NF <= '"$v_nofile_min"'){ print "nofiles:"$NF",LOW;" }
                             else if ($NF > '"$v_nofile_max"'){ print "nofiles:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile

grep -iE "LOW|HIGH|ERROR" $logfile >/dev/null 2>&1
if [ $? -eq 0 ];then
	echo "Non-Compliant"
	echo "异常,patrol用户limit设置不合规,请检查" >> $logfile
else
	echo "Compliant"
	echo "正常" > $logfile
fi

exit 0