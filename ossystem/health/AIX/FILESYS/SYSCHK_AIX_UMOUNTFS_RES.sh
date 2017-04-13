#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_UMOUNTFS_RES.sh             #
# 作  者：CCSD_liyu                           #
# 日  期：2012年 4月27日                        #
# 功  能：检查未挂载的文件系统                   #
# 复核人：                                       #
# version：  1.5                                     #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


#判断未挂载的文件系统
v_p1=`grep "V_AIX_HEA_UMOUNTFS" /home/ap/opscloud/health/AIX/AIX_HEA_PARA.txt | awk -F= '{print $2}'`
[ -z "$v_p1" ] && v_p1="zzzfffaaabbbeeennn111"
lsvg -l `lsvg -o` |grep -v "N/A"|grep -v "/cdrom" |grep "closed/syncd" | grep -Ev "$v_p1"> SYSCHK_AIX_UMOUNTFS_RES1.out

if [ -s SYSCHK_AIX_UMOUNTFS_RES1.out ]
then
echo "Non-Compliant"
echo "系统存在未挂载的文件系统" > SYSCHK_AIX_UMOUNTFS_RES.out
cat SYSCHK_AIX_UMOUNTFS_RES1.out >> SYSCHK_AIX_UMOUNTFS_RES.out
else
echo "Compliant"
echo "正常" > SYSCHK_AIX_UMOUNTFS_RES.out
echo "df 命令显示结果为:"  >> SYSCHK_AIX_UMOUNTFS_RES.out
df >> SYSCHK_AIX_UMOUNTFS_RES.out
fi
rm -f SYSCHK_AIX_UMOUNTFS_RES1.out >/dev/null 2>&1

exit 0;
