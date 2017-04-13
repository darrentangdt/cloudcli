#!/bin/sh
#************************************************#
# 文件名：SYSCHK_LINUX_FSUSED             #
# 作  者：ycl                                   #
# 日  期：2015年 12月25日                        #
# 功  能：检查文件系统利用率                     #
# 复核人：                                       #
#************************************************#

#检查临时脚本输出目录是否存在
export LANG=en_US.utf8

#mount point和相关使用率百分比大小
df -P|grep -ivE "Filesystem"|awk '{print "Filesystem:"$1,"Total:"$2,"Used:"$3,"Capacity:"$5}'
exit $?
