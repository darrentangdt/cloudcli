@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_DEVICE_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                       
rem  功  能：检查设备相关的设置项                                               
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_golbalpath=C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.获取设备信息.
echo 原始信息:>%v_outpath%\SECAUD_WIN_DEVICE.out
echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
secedit /export /cfg %v_outpath%\SECAUD_WIN_DEVICE.out >%v_outpath%\temp1.out

setlocal enabledelayedexpansion

echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_DEVICE.out
echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out

rem -----AllocateFloppies-----
set "flag=0"
type %v_outpath%\SECAUD_WIN_DEVICE.out|find "MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateFloppies" >%v_outpath%\temp.out
rem 2.获取相关信息.
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo AllocateFloppies注册表项不存在。不合规 >> %v_outpath%\SECAUD_WIN_DEVICE.out
	echo AllocateFloppies注册表项不存在。不合规 >> %v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表项的值不合规.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
		call set "var=%%var:~1,1%%"
	)
	rem 4.将字符串转换为数字.
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.检查是否合规.
	if !number! NEQ 1 (
		echo AllocateFloppies的值设置不合规. >> %v_outpath%\SECAUD_WIN_DEVICE.out
		echo AllocateFloppies的值设置不合规. >> %v_outpath%\Conviction.out
	) else (
		echo AllocateFloppies的值设置合规. >> %v_outpath%\SECAUD_WIN_DEVICE.out
	)
)

rem -----AllocateDASD-----
set "flag=0"
type %v_outpath%\SECAUD_WIN_DEVICE.out|find "MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateDASD" > %v_outpath%\temp.out
rem 2.Get Useful Information.
if errorlevel 1 (
	rem 3.Case 1. Didn't find the value,Conviction.
	echo AllocateDASD注册表项不存在。不合规 >> %v_outpath%\SECAUD_WIN_DEVICE.out
	echo AllocateDASD注册表项不存在。不合规 >> %v_outpath%\Conviction.out
) else (
	rem 3.Case 2.The value is not Complicance.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
		call set "var=%%var:~1,1%%"
	)
	rem 4.Chang String into Number
	set /a number=!var!+0
	set "flag=1"
)
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_DEVICE_AllocateDASD "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_AllocateDASD_value=%%i 
if %flag%==1 (
	rem 5.检查是否合规.
	if !number! NEQ %v_AllocateDASD_value% (
		echo AllocateDASD的值设置不合规. >> %v_outpath%\SECAUD_WIN_DEVICE.out
		echo AllocateDASD的值设置不合规. >> %v_outpath%\Conviction.out
	) else (
		echo AllocateDASD的值设置合规. >> %v_outpath%\SECAUD_WIN_DEVICE.out
	)
)

rem -----ShutdownWithoutLogon-----
set "flag=0"
type %v_outpath%\SECAUD_WIN_DEVICE.out|find "MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System\ShutdownWithoutLogon" >%v_outpath%\temp.out
rem 2.Get Useful Information.
if errorlevel 1 (
	rem 3.Case 1. Didn't find the value,Conviction.
	echo ShutdownWithoutLogon注册表项不存在。不合规 >> %v_outpath%\SECAUD_WIN_DEVICE.out
	echo ShutdownWithoutLogon注册表项不存在。不合规 >> %v_outpath%\Conviction.out
) else (
	rem 3.Case 2.The value is not Complicance.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
		call set "var=%%var:~0%%"
	)
	rem 4.Chang String into Number
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.检查是否合规.
	if !number! NEQ 0 (
		echo ShutdownWithoutLogon的值设置不合规. >> %v_outpath%\SECAUD_WIN_DEVICE.out
		echo ShutdownWithoutLogon的值设置不合规. >> %v_outpath%\Conviction.out
	) else (
		echo ShutdownWithoutLogon的值设置合规. >> %v_outpath%\SECAUD_WIN_DEVICE.out
	)
)

rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_DEVICE.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo **********>>%v_outpath%\SECAUD_WIN_DEVICE.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_DEVICE.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 