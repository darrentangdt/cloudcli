#!/bin/sh
#************************************************#
# 文件名：SECAUD_AIX_PATH_RES.sh                 
# 策略管理方：风险管理处安全技术群组            
# 脚本撰写方：生产办云平台项目组                               
# 日  期：2014年3月10日  
# 功  能：检查PATH环境变量                       
#************************************************#

v_golbalpath=/home/ap/opscloud/security/AIX
#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
sh_dir="/home/ap/opscloud/security/AIX"
log_dir="/home/ap/opscloud/logs"
cd ${log_dir} >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir ${log_dir} 
  cd ${log_dir}
fi

v_logfile="SECAUD_AIX_PATH_RES.out"

> $v_logfile

echo $PATH|grep -E '^\.:|:\.$|^\.\/|:\.\/$|:\.:|:\.\/:' >/dev/null
if [ $? -eq 0 ]; then
echo "PATH路径为$PATH,包含当前路径">>SECAUD_AIX_PATH_RES1.out
fi

echo $PATH|grep -E  "^:"  >/dev/null
if [ $? -eq 0 ]; then
echo "PATH路径为$PATH,包含以：开头路径">>SECAUD_AIX_PATH_RES1.out
fi

echo $PATH|grep '::'  >/dev/null
if [ $? -eq 0 ]; then
echo "PATH路径为$PATH,包含::路径">>SECAUD_AIX_PATH_RES1.out
fi

echo $PATH|grep -E ':$'  >/dev/null
if [ $? -eq 0 ]; then
echo "PATH路径为$PATH,包含以:结尾的路径">>SECAUD_AIX_PATH_RES1.out
fi

if [ -s SECAUD_AIX_PATH_RES1.out ];then
    echo "Non-Compliant"
    cat SECAUD_AIX_PATH_RES1.out >  $v_logfile
else
    echo "Compliant"
echo "合规" >> $v_logfile
fi

rm -f SECAUD_AIX_PATH_RES1.out
