#!/bin/sh
#************************************************#
# 文件名：SYSAUD_AIX_FSCSI_FCS_RES.sh            #
# 作  者：CCSD_YOUTONGLI                         #
# 日  期：2013年 5月8日                          #
# 功  能：检查系统参数fsfastpath设置             #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


v_logfile="SYSAUD_AIX_FSCSI_FCS_RES.out"
> $v_logfile

v_fcsN=$(lscfg -l fcs* | awk '{print $1}')
for fcsn in $v_fcsN ;do
    lsattr -El $fcsn | awk '/^init_link/{if ( $2 != "pt2pt" && $2 != "auto" ) {print "'"$fcsn"'""  "$0}}' >> $v_logfile
done

v_fscsi=$(lscfg -l fscsi* | awk '{print $1}')
for fscsiN in $v_fscsi ;do
    lsattr -El $fscsiN | awk '/^fc_err_recov/{if ($2 != "fast_fail" ) {print "'"$fscsiN"'""  "$0}}' >> $v_logfile
    lsattr -El $fscsiN | awk '/^dyntrk/{if ($2 != "yes" ) {print "'"$fscsiN"'""  "$0}}' >> $v_logfile
done


if [ -s $v_logfile ]; then
echo "Non-Compliant"
echo "正确值请参考:" >> $v_logfile
echo "fc_err_recov = fast_fail" >> $v_logfile
echo "dyntrk = yes" >> $v_logfile
echo "init_link = pt2pt" >> $v_logfile
echo "init_link = auto" >> $v_logfile
else
echo "Compliant"
echo "合规" >> $v_logfile
fi

exit 0
