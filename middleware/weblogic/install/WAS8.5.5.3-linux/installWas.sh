clear
echo "#################"
echo "# V0.3 20131210 #"
echo "#       by libc #"
echo "#################"

pid=""
if [ -r wasPid ]
then
	pid=`cat wasPid`
	pid=`ps -ef | grep 'sh install' |grep $pid | awk '{print $2}'`
fi

if [ "${pid}" == "" ]
then
	#5���ʱ�ȴ�
	for i in 5 4 3 2 1
		do
			echo $i"..."
			sleep 1
		done
	sh installWas > installWas.log &
	installPid=$!
	echo ${installPid} > wasPid
	tail --pid ${installPid} -f installWas.log
else
	echo " Error >> the install is running pid=${pid}��you can see log like this : tail --pid ${pid} -f installWas.log"
fi


