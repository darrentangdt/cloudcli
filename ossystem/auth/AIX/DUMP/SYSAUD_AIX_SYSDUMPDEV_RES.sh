#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SYSDUMPDEV_RES.sh           #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2012年12月12日                         #
# 功  能：SYSDUMPDEV -L 参数检查                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_SYSDUMPDEV_RES.out"
> $v_logfile

if [ $(sysdumpdev -l | awk '/forced copy flag/{print $NF}') = TRUE ];then
	:
else
  echo "sysdumpdev forced copy flag are not TRUE\t\t\t\tFail" >> $v_logfile
fi

if [ $(sysdumpdev -l | awk '/always allow dump/{print $NF}') = TRUE ];then
	:
else
  echo "sysdumpdev always allow dump are not TRUE\t\t\t\tFail" >> $v_logfile
fi

if [ $(sysdumpdev -l | awk '/dump compression/{print $NF}') = ON ];then
	:
else
  echo "sysdumpdev dump compression are not ON\t\t\t\tFail" >> $v_logfile
fi

if [ $(sysdumpdev -l | awk '/^copy directory/{print $NF}') = "/home/coredump" ];then
	:
else
  echo "sysdumpdev copy directory are not /home/coredump\t\t\t\tFail" >> $v_logfile
fi

if [ "$(df -m |awk '/coredump/{print $2}' | sed -e 's/.00//g')" -eq 10240 ];then
  :
else
  echo "/home/coredump (lvname=rootvgl0002) size not 10G" >> $v_logfile
fi

v_x_pp_size=$(lspv hdisk0 | awk  '/^PP SIZE/{print $3}')
v_x_dump_pp=$(lsvg -l rootvg | awk '/sysdump/{print $3}')
if [ $(echo "$v_x_pp_size * $v_x_dump_pp" | bc) -eq 10240 ];then
  :
else
   echo "lg_dumplv (sysdumpdev device) size not 10G" >> $v_logfile
fi


if [ -s $v_logfile ]; then
echo "Non-Compliant"
else
echo "Compliant"
echo "合规" >> $v_logfile
fi