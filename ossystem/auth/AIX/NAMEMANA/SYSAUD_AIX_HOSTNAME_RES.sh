#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_HOSTNAME_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查主机名命名                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


# 规范命名：行名编码（2位）+ 环境编号（1位）+ 应用名编码（3位）+服务器用途码（2位）+序号（2位）例如bj1ocrdb01
v_hostname=`hostname`
v_part1=`hostname |cut -c1-3 |grep -i "[a-z][a-z][1-9]"`
v_part2=`hostname |cut -c4-10 |grep -i "[a-z]\{5\}[0-9]\{2\}"`

if [[ "$v_part1" = "" || "$v_part2" = "" ]]; then
echo "Log"
echo "本系统主机名为[$v_hostname],主机名命名不符合规范.（规范：行名编码（2位）+ 环境编号（1位）+ 应用名编码（3位）+服务器用途码（2位）+序号（2位））" > SYSAUD_AIX_HOSTNAME_RES.out
else
echo "Log"
echo "合规" > SYSAUD_AIX_HOSTNAME_RES.out
fi




