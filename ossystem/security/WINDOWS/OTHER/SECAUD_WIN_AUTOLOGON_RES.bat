@echo off&&setlocal EnableDelayedExpansion

rem ************************************************
rem  文件名：SECAUD_WIN_AUTOLOGON_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                              
rem  功  能：检查自动登录的设置                                               
rem ************************************************

rem 检查临时脚本输出目录是否存在
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.获取自动登录信息.
echo 原始信息:>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s >>%v_outpath%\SECAUD_WIN_AUTOLOGON.out 2>&1
if !errorlevel! equ 1 (
	rem 3.注册表项不存在，合规
	echo AutoAdminLogon注册表项不存在，合规>> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
) else (
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo 中间结论：>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out

	type %v_outpath%\SECAUD_WIN_AUTOLOGON.out|find /I "AutoAdminLogon    REG_SZ    1" > %v_outpath%\temp.out
	rem 2.获取有效信息.
	if !errorlevel! equ 0 (
		rem 3.注册表项不合规
		echo AutoAdminLogon注册表项不合规>> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
		echo AutoAdminLogon注册表项不合规> %v_outpath%\Conviction.out
	) else (
		echo AutoAdminLogon注册表项合规>> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
	)
)

rem 3.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
)

rem 4.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out