@echo off&&setlocal EnableDelayedExpansion
rem ************************************************
rem  文件名：SECAUD_WIN_SERVICES_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                            
rem  功  能：检查服务的状况                                              
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

rem 1.获取服务信息.
echo 原始信息:>%v_outpath%\SECAUD_WIN_SERVICES.out
echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
sc queryex >>%v_outpath%\temp.out

for /f "tokens=2,3  delims=|" %%i in ('findstr SECK "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do (
set v_svrdname=%%i
set v_svrname=%%j
type %v_outpath%\temp.out|find "!v_svrdname!" >>%v_outpath%\temp1.out
if !errorlevel! equ 1 (
	echo !v_svrdname!未运行,合规. >> %v_outpath%\SECAUD_WIN_SERVICES.out
) else (
	echo !v_svrdname!运行中，不合规. >> %v_outpath%\SECAUD_WIN_SERVICES.out
	echo !v_svrdname!运行中，不合规. >> %v_outpath%\Conviction.out
)

sc qc !v_svrname!|find "AUTO_START" >>%v_outpath%\temp2.out

if !errorlevel! equ 0 (
	echo !v_svrdname!配置为自动启动,不合规. >> %v_outpath%\SECAUD_WIN_SERVICES.out
) else (
	echo !v_svrdname!配置非自动启动,合规. >> %v_outpath%\SECAUD_WIN_SERVICES.out
	echo !v_svrdname!配置非自动启动,合规. >> %v_outpath%\Conviction.out
)
)
rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_SERVICES.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_SERVICES.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out 
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
