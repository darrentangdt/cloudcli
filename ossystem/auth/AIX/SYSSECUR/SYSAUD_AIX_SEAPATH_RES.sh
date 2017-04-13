#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_SEAPATH_RES.sh             #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2010年 01月27日                        #
# 功  能：检查PATH变量中定义的搜索路径           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=C
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


echo $PATH|grep -E  "^:" >/dev/null && echo "ERR：PATH环境变量以：开头" > SYSAUD_AIX_SEAPATH_RES1.out
echo $PATH|grep '::' >/dev/null && echo "ERR：PATH环境变量中包含::" >> SYSAUD_AIX_SEAPATH_RES1.out
echo $PATH|grep -E ':$' >/dev/null && echo "ERR：PATH环境变量中以:结尾" >> SYSAUD_AIX_SEAPATH_RES1.out

if [ -s SYSAUD_AIX_SEAPATH_RES1.out ]; then
echo "Non-Compliant"
echo "root用户的PATH环境变量设置不合规" > SYSAUD_AIX_SEAPATH_RES.out
cat SYSAUD_AIX_SEAPATH_RES1.out >> SYSAUD_AIX_SEAPATH_RES.out
rm SYSAUD_AIX_SEAPATH_RES1.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_SEAPATH_RES.out
fi
rm -f SYSAUD_AIX_SEAPATH_RES1.out >/dev/null 2>&1
