@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_CHECKGUEST_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                           
rem  功  能：检查Guest用户是否开启                                      
rem ************************************************

rem 检查临时脚本输出目录是否存在 
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

@echo off
rem 1.获取Guest用户的信息
echo 原始信息>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
net user Guest>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out

rem 2.判断系统语言，先支持英文和中文.
type %v_outpath%\SECAUD_WIN_CHECKGUEST.out|find "User name" > %v_outpath%\temp.out
if errorlevel 1 (
	set "language=c"
)else (
	set "language=e"
)

rem 3.获取账户启用信息
setlocal enabledelayedexpansion
rem For Chinese
if %language%==c (
	type %v_outpath%\SECAUD_WIN_CHECKGUEST.out|find "帐户启用               Yes"> %v_outpath%\temp.out
	if errorlevel 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest用户未开启，合规。>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	) else (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest用户开启，不合规。>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest用户开启，不合规。>>%v_outpath%\Conviction.out
	)
)

rem For English
if %language%==e (
	type %v_outpath%\SECAUD_WIN_CHECKGUEST.out|find "Account active               Yes"> %v_outpath%\temp.out	
	if errorlevel 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest用户未开启，合规。>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	) else (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo 中间结论：>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest用户开启，不合规。>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest用户开启，不合规。>>%v_outpath%\Conviction.out
	)
)

rem 4.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_CHECKGUEST.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_CHECKGUEST.out
)

rem 5.删除临时文件.
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
if exist %v_outpath%\temp.out del %v_outpath%\temp.out