clear
#################
# V0.2 20130518 #
#       by libc #
#################

CUR_HOME=`pwd`
#判断配置文件是否存在,并export参数
if [ -r config.txt ]
then
	echo "*****************************************************************************"
	PARMS=`grep = config.txt|grep -v ^#`
	for p in $PARMS
		do
			eval p=`echo $p`
			echo $p
			export $p
		done
	echo "*****************************************************************************"
else
	echo "Error >> config file check failed! there is no config.txt file!"
	exit -1
fi

curUser=`whoami`
if [ "${curUser}" != "${RunUser}" ]
then
	echo "********************************************************"
	echo "*        you must use ${RunUser} run install...            *"
	echo "********************************************************"
	echo ""
	exit
fi


#判断进程是否存在
pid=`ps -ef | grep java |grep ${WAS_HOME} | head -1| awk '{print $2}'`
if [ "${pid}" != "" ]
then
	echo " Error >> the WAS is running......"
	exit -1
fi

for i in 3 2 1
	do
		echo $i"..."
		sleep 1
	done
	
echo "uninstall WAS..."
if [ -d ${IM_HOME}/eclipse/tools ]
then
	cd ${IM_HOME}/eclipse/tools
	./imcl uninstallAll
	
	lastPackage=`./imcl listInstalledPackages|grep "com.ibm.websphere.ND"| wc -l `
	if [ ${lastPackage} -eq 0 ]
	then
		echo " Info >> uninstall WAS Sucessed"
	else
		echo " Error >> uninstall WAS Failed"
		exit -1
	fi
	rm -rf ${WAS_HOME}
	cd ~
	cd var/ibm/InstallationManager/uninstall
	./uninstall -silent
	rm -rf ${IMShared_HOME}
else
	echo " Info >> ${IM_HOME}/eclipse/tools is not exist"
fi

echo " Info >> uninstall Sucessed"
