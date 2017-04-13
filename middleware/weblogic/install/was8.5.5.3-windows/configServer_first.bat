echo Off
call startWas.bat

echo "config WAS Server begin...."
call C:\IBM\WebSphere\AppServer\profiles\AppSrv01\bin\wsadmin.bat -lang jython -f configServer_win.py

echo "Finish"
pause;
