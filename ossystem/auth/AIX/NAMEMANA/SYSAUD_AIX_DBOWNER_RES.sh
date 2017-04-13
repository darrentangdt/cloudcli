#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_DBOWNER_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查数据库属组                         #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi

v_ora=`cat /etc/passwd |awk -F: '($1 == "oracle") {print $1}'`
v_inf=`cat /etc/passwd |awk -F: '($1 == "informix") {print $1}'`
cat /etc/group |awk -F: '($1 == "dba") {print $4}' |grep "oracle" > SYSAUD_AIX_DBOWNER_RES1.out
cat /etc/group |awk -F: '($1 == "informix") {print $4}' |grep "informix" > SYSAUD_AIX_DBOWNER_RES2.out

if [ -n "$v_ora" ]; then
if [ -s SYSAUD_AIX_DBOWNER_RES1.out ]; then
  echo "Compliant"
  echo "合规" > SYSAUD_AIX_DBOWNER_RES.out
  else
  echo "Non-Compliant"
  echo "当前oracle用户的属组不为dba,属不合规" > SYSAUD_AIX_DBOWNER_RES.out
fi
  elif [ -n "$v_inf" ]; then
  if [ -s SYSAUD_AIX_DBOWNER_RES2.out ]; then
  echo "Compliant"
  echo "合规" > SYSAUD_AIX_DBOWNER_RES.out
  else
  echo "Non-Compliant"
  echo "当前informix用户的属组不为informix，属不合规" > SYSAUD_AIX_DBOWNER_RES.out
  fi
else
  echo "Compliant"
  echo "合规" > SYSAUD_AIX_DBOWNER_RES.out
fi
rm -f SYSAUD_AIX_DBOWNER_RES1.out
rm -f SYSAUD_AIX_DBOWNER_RES2.out