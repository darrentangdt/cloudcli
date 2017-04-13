#!/bin/sh
#**************************************************#
# 文件名：SYSAUD_AIX_PATROLULIMIT_RES.sh           #
# 作  者：CCSD_liyu                                #
# 日  期：2012年11月12日                           #
# 功  能：检查PATROL用户的ulimit设置情况           #
# 复核人：                                         #
#**************************************************#

#检查临时脚本输出目录是否存在
uname | grep HP-UX >/dev/null 2>&1
if [ $? -eq 0 ]; then
export LANG=en_US.utf8.utf8
else
export LANG=en_US.utf8
fi
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#AIX：   data 1024M，stack 512M，rss 512M fsize 200M；nofiles 4096
#HP-UX:  data 512M；stack 256M；memory 256M；file 100M；nofiles 4096
#Linux:  data 512M；stack 256M；memory 256M；file 100M；nofile  4096

logfile="SYSAUD_AIX_PATROLULIMIT_RES.out"
> $logfile

id patrol >/dev/null 2>&1
if [ $? -ne 0 ];then
	echo "Non-Compliant"
	echo "patrol 用户不存在" >> $logfile
  exit 0
fi

if [ $(uname) = "AIX" ];then 
    v_parameterfile="/home/ap/opscloud/audit/AIX/AIX_AUD_PARA.txt"
    v_data_min=$(grep "V_PATROLULIMIT_DATA_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_data_min" ] && v_data_min="948576"
    v_stack_min=$(grep "V_PATROLULIMIT_STACK_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_stack_min" ] && v_stack_min="514288"
    v_memory_min=$(grep "V_PATROLULIMIT_MEMORY_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_memory_min" ] && v_memory_min="514288"
    v_file_min=$(grep "V_PATROLULIMIT_FILE_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_file_min" ] && v_file_min="4194304"
    v_nofiles_min=$(grep "V_PATROLULIMIT_NOFILES_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_nofiles_min" ] && v_nofiles_min="4096"
    v_data_max=$(grep "V_PATROLULIMIT_DATA_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_data_max" ] && v_data_max="1148576"
    v_stack_max=$(grep "V_PATROLULIMIT_STACK_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_stack_max" ] && v_stack_max="534288"
    v_memory_max=$(grep "V_PATROLULIMIT_MEMORY_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_memory_max" ] && v_memory_max="534288"
    v_file_max=$(grep "V_PATROLULIMIT_FILE_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_file_max" ] && v_file_max="4200000"
    v_nofiles_max=$(grep "V_PATROLULIMIT_NOFILES_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_nofiles_max" ] && v_nofiles_max="8192"
elif [ $(uname) = "HP-UX" ];then
    v_parameterfile="/home/ap/opsware/agent/scripts/AUDIT/HPUX/HPUX_AUD_PARA.txt"
    v_data_min=$(grep "V_PATROLULIMIT_DATA_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_data_min" ] && v_data_min="524288"
    v_stack_min=$(grep "V_PATROLULIMIT_STACK_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_stack_min" ] && v_stack_min="262144"
    v_memory_min=$(grep "V_PATROLULIMIT_MEMORY_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_memory_min" ] && v_memory_min="262144"
    v_file_min=$(grep "V_PATROLULIMIT_FILE_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_file_min" ] && v_file_min="102400"
    v_nofiles_min=$(grep "V_PATROLULIMIT_NOFILES_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_nofiles_min" ] && v_nofiles_min="4096"
    v_data_max=$(grep "V_PATROLULIMIT_DATA_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_data_max" ] && v_data_max="1048576"
    v_stack_max=$(grep "V_PATROLULIMIT_STACK_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_stack_max" ] && v_stack_max="524288"
    v_memory_max=$(grep "V_PATROLULIMIT_MEMORY_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_memory_max" ] && v_memory_max="524288"
    v_file_max=$(grep "V_PATROLULIMIT_FILE_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_file_max" ] && v_file_max="204800"
    v_nofiles_max=$(grep "V_PATROLULIMIT_NOFILES_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_nofiles_max" ] && v_nofiles_max="8192"
elif [ $(uname) = "Linux" ];then
    v_parameterfile="/home/ap/opsware/agent/scripts/AUDIT/LINUX/LINUX_AUD_PARA.txt"
    v_linux_data_min=$(grep "V_PATROLULIMIT_DATA_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_data_min" ] && v_linux_data_min="524288"
    v_linux_stack_min=$(grep "V_PATROLULIMIT_STACK_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_stack_min" ] && v_linux_stack_min="262144"
    v_linux_max_memory_size_min=$(grep "V_PATROLULIMIT_MAX_MEMORY_SIZE_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_max_memory_size_min" ] && v_linux_max_memory_size_min="262144"
    v_linux_file_size_min=$(grep "V_PATROLULIMIT_FILE_SIZE_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_file_size_min" ] && v_linux_file_size_min="102400"
    v_linux_open_files_min=$(grep "V_PATROLULIMIT_OPEN_FILES_MIN" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_open_files_min" ] && v_linux_open_files_min="4096"
    v_linux_data_max=$(grep "V_PATROLULIMIT_DATA_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_data_max" ] && v_linux_data_max="1048576"
    v_linux_stack_max=$(grep "V_PATROLULIMIT_STACK_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_stack_max" ] && v_linux_stack_max="524288"
    v_linux_max_memory_size_max=$(grep "V_PATROLULIMIT_MAX_MEMORY_SIZE_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_max_memory_size_max" ] && v_linux_max_memory_size_max="524288"
    v_linux_file_size_max=$(grep "V_PATROLULIMIT_FILE_SIZE_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_file_size_max" ] && v_linux_file_size_max="204800"
    v_linux_open_files_max=$(grep "V_PATROLULIMIT_OPEN_FILES_MAX" $v_parameterfile | awk -F= '{print $2}')
    [ -z "$v_linux_open_files_max" ] && v_linux_open_files_max="8192"
fi

if [ $(uname) != "Linux" ];then 
#data
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^data/{ {if ($NF >= '"$v_data_min"' && $NF <= '"$v_data_max"'){ print "data:"$NF",OK;" }
                               else if ($NF < '"$v_data_min"'){ print "data:"$NF",LOW;" }
                             else if ($NF > '"$v_data_max"'){ print "data:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#stack
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^stack/{ {if ($NF >= '"$v_stack_min"' && $NF <= '"$v_stack_max"'){ print "stack:"$NF",OK;" }
                               else if ($NF < '"$v_stack_min"'){ print "stack:"$NF",LOW;" }
                             else if ($NF > '"$v_stack_max"'){ print "stack:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#memory
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^memory/{ {if ($NF >= '"$v_memory_min"' && $NF <= '"$v_memory_max"'){ print "memory:"$NF",OK;" }
                               else if ($NF < '"$v_memory_min"'){ print "memory:"$NF",LOW;" }
                             else if ($NF > '"$v_memory_max"'){ print "memory:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#file
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^file/{ {if ($NF >= '"$v_file_min"' && $NF <= '"$v_file_max"'){ print "file:"$NF",OK;" }
                               else if ($NF < '"$v_file_min"'){ print "file:"$NF",LOW;" }
                             else if ($NF > '"$v_file_max"'){ print "file:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#nofiles
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^nofiles/{ {if ($NF >= '"$v_nofiles_min"' && $NF <= '"$v_nofiles_max"'){ print "nofiles:"$NF",OK;" }
                               else if ($NF < '"$v_nofiles_min"'){ print "nofiles:"$NF",LOW;" }
                             else if ($NF > '"$v_nofiles_max"'){ print "nofiles:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
if [ $(uname) = "AIX" ];then
su - patrol -c "ulimit -a" | awk '/^coredump/{if($NF == 2097152){print $0"\t\tOK"} else {print $0"\t\tERROR"}}'  >> $logfile
su - patrol -c "ulimit -a" | awk '/^processes/{if($NF == "unlimited"){print $0"\t\tOK"} else {print $0"\t\tERROR"}}'  >> $logfile				 
fi
						
else
#data
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^data/{ {if ($NF >= '"$v_linux_data_min"' && $NF <= '"$v_linux_data_max"'){ print "data:"$NF",OK;" }
                               else if ($NF < '"$v_linux_data_min"'){ print "data:"$NF",LOW;" }
                             else if ($NF > '"$v_linux_data_max"'){ print "data:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#stack
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^stack/{ {if ($NF >= '"$v_linux_stack_min"' && $NF <= '"$v_linux_stack_max"'){ print "stack:"$NF",OK;" }
                               else if ($NF < '"$v_linux_stack_min"'){ print "stack:"$NF",LOW;" }
                             else if ($NF > '"$v_linux_stack_max"'){ print "stack:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#max memory size
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^max memory size/{ {if ($NF >= '"$v_linux_max_memory_size_min"' && $NF <= '"$v_linux_max_memory_size_max"'){ print "max memory size:"$NF",OK;" }
                               else if ($NF < '"$v_linux_max_memory_size_min"'){ print "max memory size:"$NF",LOW;" }
                             else if ($NF > '"$v_linux_max_memory_size_max"'){ print "max memory size:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#file size
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^file size/{ {if ($NF >= '"$v_linux_file_size_min"' && $NF <= '"$v_linux_file_size_max"'){ print "file size,"$NF",OK;" }
                               else if ($NF < '"$v_linux_file_size_min"'){ print "file size,"$NF",LOW;" }
                             else if ($NF > '"$v_linux_file_size_max"'){ print "file size,"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
#open files
su - patrol -c "ulimit -a" | sed 's/unlimited/9999999/g' | \
 awk '/^open files/{ {if ($NF >= '"$v_linux_open_files_min"' && $NF <= '"$v_linux_open_files_max"'){ print "open files:"$NF",OK;" }
                               else if ($NF < '"$v_linux_open_files_min"'){ print "open files:"$NF",LOW;" }
                             else if ($NF > '"$v_linux_open_files_max"'){ print "open files:"$NF",HIGH;" }}}' |sed 's/9999999/unlimited/g' >> $logfile
su - patrol -c "ulimit -a" | awk '/^pipe size/{print "pipe size:"$NF",OK;" }' >> $logfile
fi

grep -iE "LOW|HIGH|ERROR" $logfile >/dev/null 2>&1
if [ $? -eq 0 ];then
	echo "Non-Compliant"
else
	echo "Compliant"
fi

exit 0
