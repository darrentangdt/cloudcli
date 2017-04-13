clear
echo "#################"
echo "# V0.3 20131210 #"
echo "#       by libc #"
echo "#################"

pid=""
if [ -r ihsPid ]
then
	pid=`cat ihsPid`
	pid=`ps -ef | grep 'sh install' |grep $pid | awk '{print $2}'`
fi

if [ "${pid}" == "" ]
then
	#5Ãë¼ÆÊ±µÈ´ý
	for i in 5 4 3 2 1
		do
			echo $i"..."
			sleep 1
		done
	sh installIhs > installIhs.log &
	installPid=$!
	echo ${installPid} > ihsPid
	tail --pid ${installPid} -f installIhs.log
else
	echo " Error >> the install is running pid=${pid}£¬you can see log like this : tail --pid ${pid} -f installIhs.log"
fi


