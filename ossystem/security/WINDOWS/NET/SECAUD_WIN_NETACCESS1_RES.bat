@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_NETACCESS_RES1.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日                          
rem  功  能：检查网络访问的设置                                            
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

rem 1.获取网络访问信息.
echo 原始信息:>%v_outpath%\SECAUD_WIN_NETACCESS1.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\DisableDomainCreds" >>%v_outpath%\SECAUD_WIN_NETACCESS1.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous" >>%v_outpath%\SECAUD_WIN_NETACCESS1.out

setlocal enabledelayedexpansion

echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out

rem -----DisableDomainCreds-----
set "flag=0"
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\DisableDomainCreds" > %v_outpath%\temp1.out
rem 2.获取有效信息
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo DisableDomainCreds注册表项不存在。不合规 >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo DisableDomainCreds注册表项不存在。不合规 >> %v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表的值设置不合规.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp1.out') do (
		set "var=%%i"
	)
	rem 4.将字符串转换为数字.
	set /a v_number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.检查是否合规.
	if !v_number! NEQ 1 (
		echo DisableDomainCreds不合规. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
		echo DisableDomainCreds不合规. >> %v_outpath%\Conviction.out
	) else (
		echo DisableDomainCreds合规. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	)
)

rem -----EveryoneIncludesAnonymous-----
set "flag=0"
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous" > %v_outpath%\temp1.out
rem 2.获取有效信息
if errorlevel 1 (
	rem 3.情况1,未找到相应的注册表项
	echo EveryoneIncludesAnonymous注册表项不存在。不合规 >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo EveryoneIncludesAnonymous注册表项不存在。不合规 >> %v_outpath%\Conviction.out
) else (
	rem 3.情况2,注册表的值设置不合规.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp1.out') do (
		set "var=%%i"
	)
	rem 4.将字符串转换为数字.
	set /a v_number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.检查是否合规.
	if !v_number! NEQ 0 (
		echo EveryoneIncludesAnonymous不合规. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
		echo EveryoneIncludesAnonymous不合规. >> %v_outpath%\Conviction.out
	) else (
		echo EveryoneIncludesAnonymous合规. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	)
)

rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 