@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_CDROM_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                            
rem  功  能：检查CDROM的设置                                              
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.获取CDROM信息.
echo 原始信息:>%v_outpath%\SECAUD_WIN_CDROM.out
echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
secedit /export /cfg %v_outpath%\SECAUD_WIN_CDROM.out > %v_outpath%\temp.out

setlocal enabledelayedexpansion


echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_CDROM.out
echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
set "flag=0"
type %v_outpath%\SECAUD_WIN_CDROM.out|find "MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateCDRoms" > %v_outpath%\temp.out 2>&1
rem 2.获取有效信息.
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo AllocateCDRoms注册表项不存在。不合规>> %v_outpath%\SECAUD_WIN_CDROM.out
	echo AllocateCDRoms注册表项不存在。不合规>> %v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表的值设置不合规.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
	)
	rem 4.将字符串转换为数字.
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.检查是否合规.
	if !number! NEQ 1 (
		echo AllocateCDRoms的值设置不合规.>> %v_outpath%\SECAUD_WIN_CDROM.out
		echo AllocateCDRoms的值设置不合规.>> %v_outpath%\Conviction.out
	) else (
		echo AllocateCDRoms合规.>> %v_outpath%\SECAUD_WIN_CDROM.out
	)
)
rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_CDROM.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_CDROM.out
)
rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 