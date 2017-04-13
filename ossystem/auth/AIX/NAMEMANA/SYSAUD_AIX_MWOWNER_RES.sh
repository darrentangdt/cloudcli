#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_MWOWNER_RES.sh              #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月18日                        #
# 功  能：检查中间件用户属组                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


cat /etc/group |awk -F: '( $1 != "tuxedo" ) {print $0}' |grep "tuxedo" > SYSAUD_AIX_MWOWNER_RES1.out
if [ -s SYSAUD_AIX_MWOWNER_RES1.out ]; then
echo "tuxedo用户的属组名不合规" >> SYSAUD_AIX_MWOWNER_RES2.out
cat SYSAUD_AIX_MWOWNER_RES1.out >> SYSAUD_AIX_MWOWNER_RES2.out
fi

cat /etc/group |awk -F: '( $1 != "weblogic" ) {print $0}' |grep "weblogic" > SYSAUD_AIX_MWOWNER_RES1.out
if [ -s SYSAUD_AIX_MWOWNER_RES1.out ]; then
echo "weblogic用户的属组名不合规" >> SYSAUD_AIX_MWOWNER_RES2.out
cat SYSAUD_AIX_MWOWNER_RES1.out >> SYSAUD_AIX_MWOWNER_RES2.out
fi

cat /etc/group |awk -F: '( $1 != "mqm" ) {print $0}' |grep "mqm" > SYSAUD_AIX_MWOWNER_RES1.out
if [ -s SYSAUD_AIX_MWOWNER_RES1.out ]; then
echo "mqm用户的属组名不合规" >> SYSAUD_AIX_MWOWNER_RES2.out
cat SYSAUD_AIX_MWOWNER_RES1.out >> SYSAUD_AIX_MWOWNER_RES2.out
fi

cat /etc/group |awk -F: '( $1 != "websphere" ) {print $0}' |grep "websphere" > SYSAUD_AIX_MWOWNER_RES1.out
if [ -s SYSAUD_AIX_MWOWNER_RES1.out ]; then
echo "websphere用户的属组名不合规" >> SYSAUD_AIX_MWOWNER_RES2.out
cat SYSAUD_AIX_MWOWNER_RES1.out >> SYSAUD_AIX_MWOWNER_RES2.out
fi

cat /etc/group |awk -F: '( $1 != "mqbrkrs" ) {print $0}' |grep "mqbrkrs" > SYSAUD_AIX_MWOWNER_RES1.out
if [ -s SYSAUD_AIX_MWOWNER_RES1.out ]; then
echo "mqbrkrs用户的属组名不合规" >> SYSAUD_AIX_MWOWNER_RES2.out
cat SYSAUD_AIX_MWOWNER_RES1.out >> SYSAUD_AIX_MWOWNER_RES2.out
fi

  if [ -s SYSAUD_AIX_MWOWNER_RES2.out ]; then
  echo "Non-Compliant"
  mv SYSAUD_AIX_MWOWNER_RES2.out SYSAUD_AIX_MWOWNER_RES.out
  else
  echo "Compliant"
  echo "合规" > SYSAUD_AIX_MWOWNER_RES.out
  fi

rm -f SYSAUD_AIX_MWOWNER_RES1.out >/dev/null 2>&1
rm -f SYSAUD_AIX_MWOWNER_RES2.out >/dev/null 2>&1
