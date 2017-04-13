#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_UNIXIMAGE_RES.sh            #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：20010年 1月15日                        #
# 功  能：检查系统是否为64位                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_unix_image=`ls -l /unix |awk '{print $11}'`
v_bit=`bootinfo -K`
if [ $v_bit = 64 ]
then
if [ $v_unix_image != /usr/lib/boot/unix_64 ]
then
echo "Non-Compliant"
echo "aix的/unix文件链接不正确,属不合规" > SYSAUD_AIX_UNIXIMAGE_RES.out
else
echo "Compliant"
echo "合规" > SYSAUD_AIX_UNIXIMAGE_RES.out
fi
else
echo "Non-Compliant"
echo "本机AIX系统非64位" > SYSAUD_AIX_UNIXIMAGE_RES.out
fi