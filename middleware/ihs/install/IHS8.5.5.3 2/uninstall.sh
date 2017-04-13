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
pid=`ps -ef | grep httpd |grep ${IHS_HOME} | head -1| awk '{print $2}'`
if [ "${pid}" != "" ]
then
	echo " Error >> the IHS is running......"
	exit -1
fi

for i in 3 2 1
	do
		echo $i"..."
		sleep 1
	done
	
echo "uninstall all..."
cd ${MY_HOME}/ToolBox/WCT
./wctcmd.sh -tool pct -removeDefinitionLocation plugin -defLocPathname ${PLG_HOME}
if [ -d ${IM_HOME}/eclipse/tools ]
then
	cd ${IM_HOME}/eclipse/tools
	./imcl uninstallAll
	
	lastPackage=`./imcl listInstalledPackages|grep "com.ibm.websphere.IHS"| wc -l `
	if [ ${lastPackage} -eq 0 ]
	then
		echo " Info >> uninstall IHS Sucessed"
	else
		echo " Error >> uninstall IHS Failed"
		exit -1
	fi
	cd ~
	cd var/ibm/InstallationManager/uninstall
	./uninstall -silent
	cd ${MY_HOME}
	rm -rf *
else
	echo " Info >> ${IM_HOME}/eclipse/tools is not exist"
fi

echo " Info >> uninstall Sucessed"
