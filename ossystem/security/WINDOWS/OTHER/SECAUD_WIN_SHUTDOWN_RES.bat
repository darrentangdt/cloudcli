@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_SHUTDOWN_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                           
rem  功  能：检查关机清理虚拟内存页面文件设置                                             
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


rem 1.获取关机清理虚拟内存页面文件设置。
echo 原始信息:>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
secedit /export /cfg %v_outpath%\temp.out > %v_outpath%\temp1.out

setlocal enabledelayedexpansion

rem 2.检查关机清理虚拟内存页面文件设置
set "flag=0"
echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management\ClearPageFileAtShutdown" >>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo ClearPageFileAtShutdown不存在。不合规>> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo ClearPageFileAtShutdown不存在。不合规>> %v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表的值设置不合规.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\SECAUD_WIN_SHUTDOWN.out') do (
		set "var=%%i"
	)
	rem 4.将字符串转换为数字.
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.检查是否合规.
	if !number! NEQ 1 (
		echo ClearPageFileAtShutdown的值设置不合规.>> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
		echo ClearPageFileAtShutdown的值设置不合规.>%v_outpath%\Conviction.out
	)else (
		echo ClearPageFileAtShutdown的值设置合规.>> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
	)
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out