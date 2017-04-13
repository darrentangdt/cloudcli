@echo off
rem ************************************************
rem  文件名：SECAUD_WIN_PASSWORD_RES.bat       
rem  策略管理方：风险管理处安全技术群组            
rem  脚本撰写方：生产办云平台项目组                               
rem  日  期：2014年3月10日 
rem  功  能：检查密码安全相关                                     
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

rem 1.获取密码信息.
echo 原始信息>%v_outpath%\SECAUD_WIN_PASSWORD.out
echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
secedit /export /cfg %v_outpath%\temp.out > %v_outpath%\temp1.out
type %v_outpath%\temp.out|find "MaximumPasswordAge =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "MinimumPasswordLength =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "PasswordComplexity =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "PasswordHistorySize =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "ClearTextPassword =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out

echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
echo 中间结论：>>%v_outpath%\SECAUD_WIN_PASSWORD.out
echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out

rem -----查看MaximumPasswordAge是否合规-----
type %v_outpath%\temp.out|find "MaximumPasswordAge =" > %v_outpath%\temp2.out

rem 2.过滤信息，去除空格.
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)

rem 3.将字符串转换为数字
set /a v_number=%var%+0
rem 4.进行合规性比对
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSWORD_MaximumPasswordAge "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_MaximumPasswordAge_value=%%i 
if %v_number% NEQ %v_MaximumPasswordAge_value% (
	echo MaximumPasswordAge（ %v_number% ）不等于%v_MaximumPasswordAge_value%，不合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo MaximumPasswordAge不等于%v_MaximumPasswordAge_value%，不合规.>>%v_outpath%\Conviction.out
) else (
	echo MaximumPasswordAge（ %v_number% ）合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----查看MinimumPasswordLength是否合规-----
type %v_outpath%\temp.out|find "MinimumPasswordLength =" > %v_outpath%\temp2.out
rem 2.过滤信息，去除空格.
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.将字符串转换为数字
set /a v_number=%var%+0
rem 4.进行合规性比对
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSWORD_MinimumPasswordLength "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_MinimumPasswordLength_value=%%i 
if %v_number% NEQ %v_MinimumPasswordLength_value% (
	echo MinimumPasswordLength（ %v_number% ）不等于%v_MinimumPasswordLength_value%，不合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo MinimumPasswordLength不等于%v_MinimumPasswordLength_value%，不合规.>>%v_outpath%\Conviction.out
) else (
	echo MinimumPasswordLength（ %v_number% ）合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----查看PasswordComplexity是否合规-----
type %v_outpath%\temp.out|find "PasswordComplexity =" > %v_outpath%\temp2.out
rem 2.过滤信息，去除空格.
rem 去除空格
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.将字符串转换为数字
set /a v_number=%var%+0
rem 4.进行合规性比对
if %v_number% EQU 0 (
	echo PasswordComplexity（ %v_number% ）未设置，不合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo PasswordComplexity未设置，不合规.>>%v_outpath%\Conviction.out
) else (
	echo PasswordComplexity（ %v_number% ）合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----查看PasswordHistorySize是否合规-----
type %v_outpath%\temp.out|find "PasswordHistorySize =" > %v_outpath%\temp2.out
rem 2.过滤信息，去除空格.
rem 去除空格
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.将字符串转换为数字
set /a v_number=%var%+0
rem 4.进行合规性比对
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSWORD_PasswordHistorySize "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_PasswordHistorySize_value=%%i 
if %v_number% NEQ %v_PasswordHistorySize_value% (
	echo PasswordHistorySize（ %v_number% ）不等于%v_PasswordHistorySize_value%，不合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo PasswordHistorySize不等于%v_PasswordHistorySize_value%，不合规.>>%v_outpath%\Conviction.out
) else (
	echo PasswordHistorySize（ %v_number% ）合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----查看ClearTextPassword是否合规-----
type %v_outpath%\temp.out|find "ClearTextPassword =" > %v_outpath%\temp2.out
rem 2.过滤信息，去除空格.
rem 去除空格
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.将字符串转换为数字
set /a v_number=%var%+0
rem 4.进行合规性比对
if %v_number% EQU 1 (
	echo ClearTextPassword（ %v_number% ）已开启，不合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo ClearTextPassword已开启，不合规.>>%v_outpath%\Conviction.out
) else (
	echo ClearTextPassword（ %v_number% ）合规.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem 5.得出合规结论
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo "不合规" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo 最终结论：>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo "合规" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem 6.删除临时文件.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out
