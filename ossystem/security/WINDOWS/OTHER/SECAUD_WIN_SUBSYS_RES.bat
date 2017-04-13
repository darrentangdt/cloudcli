@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_SUBSYS_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                          
rem  功  能：检查子系统是否开启了POSIX                                    
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.获取子系统信息。
echo 原始信息:>%v_outpath%\SECAUD_WIN_SUBSYS.out
echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out

setlocal enabledelayedexpansion

rem 2.检查子系统是否开启了POSIX
echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_SUBSYS.out
echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Session Manager\SubSystems\optional" >>%v_outpath%\SECAUD_WIN_SUBSYS.out
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo SubSystems\optional不存在。不合规>> %v_outpath%\SECAUD_WIN_SUBSYS.out
	echo SubSystems\optional不存在。不合规>> %v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表的值设置不合规.
	type %v_outpath%\SECAUD_WIN_SUBSYS.out|find "Posix" >%v_outpath%\temp1.out
	if errorlevel 1 (
		echo 子系统未开启了Posix。合规>> %v_outpath%\SECAUD_WIN_SUBSYS.out
	)else (
		echo 子系统开启了Posix。不合规>> %v_outpath%\SECAUD_WIN_SUBSYS.out
		echo 子系统开启了Posix。不合规.>>%v_outpath%\Conviction.out
	)
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_SUBSYS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_SUBSYS.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 