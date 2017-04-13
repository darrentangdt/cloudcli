#!/bin/sh
#************************************************#
# 文件名：SYSCHK_AIX_ERRPT_RES.sh                #
# 作  者：CCSD_YOUTONGLI                            #
# 日  期：2009年 12月30日                        #
# 功  能：检查有无新的错误日志                   #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8
cd ./tmp >/dev/null 2>&1
if [ $? -ne 0 ]; then
  mkdir tmp 
  cd ./tmp
fi


lastday()
{
#取系统前一天日期函数
  rq=`date +20%y%m%d`
  oldrq=`echo $rq-1 | bc`
  oldy=`echo $oldrq | cut -c1-4`
  if [ `echo $oldrq | cut -c7-8` = "00" ];then
    mm=`echo $oldrq | cut -c5-6`
    case $mm in
    01)
        oldy=`echo $oldy-1|bc`
        oldmd="1231"
        oldday=$oldy$oldmd;;
    02|04|06|09|11)
        moth=`echo $mm-1|bc`
        oldday=$oldy"0"$moth"31";;
    03)
        r=`cal 02 $oldy|sed "$"d|sed -n "$"p|awk '{print $NF}'`
        oldday=$oldy"02"$r;;
    05|07|08|10|12)
        moth=`echo $mm-1|bc`
        if [ "$mm" = "08" ];then
           oldday=$oldy"0"$moth"31"
        else
           oldday=$oldy"0"$moth"30"
        fi;;
   esac
   else
      oldday=$oldrq
   fi
echo $oldday
}
lastday=`lastday`

#确定年,月,日,时,分的时间变量
if [ -f SYSCHK_AIX_ERRPT_RES.out ]; then
v_file_time=`ls -l SYSCHK_AIX_ERRPT_RES.out |awk '{print $8}' |grep ":"`
v_mon=`ls -l SYSCHK_AIX_ERRPT_RES.out |awk '{print $6}'`
v_day=`ls -l SYSCHK_AIX_ERRPT_RES.out |awk '{print $7}'`

if [ "$v_file_time" = "" ]; then
v_year=`ls -l SYSCHK_AIX_ERRPT_RES.out |awk '{print $8}' |cut -c3-4`
v_hour=`date +%H`
v_min=`date +%M`
else
v_year=`date +%y`
v_hour=`ls -l SYSCHK_AIX_ERRPT_RES.out |awk '{print $8}' |awk -F: '{print $1}'`
v_min=`ls -l SYSCHK_AIX_ERRPT_RES.out |awk '{print $8}' |awk -F: '{print $2}'`
fi

if [ $v_mon = Jan ]; then
v_mon=01
elif [ $v_mon = Feb ]; then
v_mon=02
elif [ $v_mon = Mar ]; then
v_mon=03
elif [ $v_mon = Apr ]; then
v_mon=04
elif [ $v_mon = May ]; then
v_mon=05
elif [ $v_mon = Jun ]; then
v_mon=06
elif [ $v_mon = Jul ]; then
v_mon=07
elif [ $v_mon = Aug ]; then
v_mon=08
elif [ $v_mon = Sep ]; then
v_mon=09
elif [ $v_mon = Oct ]; then
v_mon=10
elif [ $v_mon = Nov ]; then
v_mon=11
elif [ $v_mon = Dec ]; then
v_mon=12
fi

else
v_year=`date +%y`
v_mon=`echo "$lastday" |cut -c5-6`
v_day=`echo "$lastday" |cut -c7-8`
v_hour=`date +%H`
v_min=`date +%M`
fi

v_daynum=`echo "$v_day" |wc -c`
if [ $v_daynum -eq 2 ]; then
v_day=`echo "0$v_day"`
fi

#执行判断并生成文件
errpt -s $v_mon$v_day$v_hour$v_min$v_year > SYSCHK_AIX_ERRPT_RES.out

if [ -s SYSCHK_AIX_ERRPT_RES.out ]; then
  echo "Non-Compliant"
  else
  echo "Compliant"
  echo "正常" > SYSCHK_AIX_ERRPT_RES.out
fi

exit 0;