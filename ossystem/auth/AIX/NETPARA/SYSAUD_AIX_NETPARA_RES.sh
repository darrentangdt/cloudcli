#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_NETPARA_RES.sh              #
# 作  者：CCSD_liyu                              #
# 日  期：2012年02月25日                         #
# 功  能：检查系统参数tcp_finwait2设置           #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_NETPARA_RES.out"
> $v_logfile

no -aF | awk -F= '/ipqmaxlen/{if ($2 == 512){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile
no -aF | awk -F= '/sb_max/{if ($2 == 4194304){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile
no -aF | awk -F= '/udp_recvspace/{if ($2 == 1048576){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile
no -aF | awk -F= '/udp_sendspace/{if ($2 == 1048576){}else{print  $1"\tis\t"$2"\t\t\t\t\tno change"}}' >> $v_logfile


if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "请参考下面要求值进行修改:" >> $v_logfile
echo "ccb规范为:ipqmaxlen=512;sb_max=4194304;udp_recvspace=1048576;udp_sendspace=1048576" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0