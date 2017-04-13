#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_CHANNELPORTUP_RES.sh        #
# 作  者：CCSD_liyu                              #
# 日  期：2012年12月12日                         #
# 功  能：双网卡绑定端口状态检查                 #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_CHANNELPORTUP_RES.out"
> $v_logfile

v_ip_ent=$(netstat -in | awk '/^en/{print $1}'|uniq|sed 's/en/ent/g')
for sss in $v_ip_ent;do
  entstat -d $sss| grep  EtherChannel >/dev/null
    if [ $? -eq 0 ];then
      v_stat=$(entstat -d $sss | grep "Link Status : Up" |wc -l)
        if [ $v_stat -eq 2 ];then
                :
        else
                echo "EtherChannel $sss 2 port link stat:" >> $v_logfile
                entstat -d $sss | grep "Link Status :" >> $v_logfile
        fi
    fi
done

if [ -s $v_logfile ]; then
echo "Non-Compliant"
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0