#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_ROOTMIRROR_RES.sh           #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2010年 1月15日                        #
# 功  能：检查RootVG 是否被正确地镜像            #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_ROOTMIRROR_RES.out"
> $v_logfile

  v_quorum=$(lsvg rootvg | awk '/QUORUM/{print $5}')
  if [ $v_quorum -eq 1 ] ;then
     echo "Compliant"
     echo "合规" >> $v_logfile
  else
     echo "Non-Compliant"
     echo "rootvg 没有按照标准做磁盘镜像!!!" >> $v_logfile
  fi

exit 0