@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_PASSWORD_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10�� 
rem  ��  �ܣ�������밲ȫ���                                     
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_golbalpath=C:\Program Files\opsware\agent\scripts\SECURITY\WINDOWS
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡ������Ϣ.
echo ԭʼ��Ϣ>%v_outpath%\SECAUD_WIN_PASSWORD.out
echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
secedit /export /cfg %v_outpath%\temp.out > %v_outpath%\temp1.out
type %v_outpath%\temp.out|find "MaximumPasswordAge =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "MinimumPasswordLength =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "PasswordComplexity =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "PasswordHistorySize =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
type %v_outpath%\temp.out|find "ClearTextPassword =" >> %v_outpath%\SECAUD_WIN_PASSWORD.out

echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_PASSWORD.out
echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out

rem -----�鿴MaximumPasswordAge�Ƿ�Ϲ�-----
type %v_outpath%\temp.out|find "MaximumPasswordAge =" > %v_outpath%\temp2.out

rem 2.������Ϣ��ȥ���ո�.
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)

rem 3.���ַ���ת��Ϊ����
set /a v_number=%var%+0
rem 4.���кϹ��Աȶ�
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSWORD_MaximumPasswordAge "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_MaximumPasswordAge_value=%%i 
if %v_number% NEQ %v_MaximumPasswordAge_value% (
	echo MaximumPasswordAge�� %v_number% ��������%v_MaximumPasswordAge_value%�����Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo MaximumPasswordAge������%v_MaximumPasswordAge_value%�����Ϲ�.>>%v_outpath%\Conviction.out
) else (
	echo MaximumPasswordAge�� %v_number% ���Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----�鿴MinimumPasswordLength�Ƿ�Ϲ�-----
type %v_outpath%\temp.out|find "MinimumPasswordLength =" > %v_outpath%\temp2.out
rem 2.������Ϣ��ȥ���ո�.
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.���ַ���ת��Ϊ����
set /a v_number=%var%+0
rem 4.���кϹ��Աȶ�
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSWORD_MinimumPasswordLength "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_MinimumPasswordLength_value=%%i 
if %v_number% NEQ %v_MinimumPasswordLength_value% (
	echo MinimumPasswordLength�� %v_number% ��������%v_MinimumPasswordLength_value%�����Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo MinimumPasswordLength������%v_MinimumPasswordLength_value%�����Ϲ�.>>%v_outpath%\Conviction.out
) else (
	echo MinimumPasswordLength�� %v_number% ���Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----�鿴PasswordComplexity�Ƿ�Ϲ�-----
type %v_outpath%\temp.out|find "PasswordComplexity =" > %v_outpath%\temp2.out
rem 2.������Ϣ��ȥ���ո�.
rem ȥ���ո�
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.���ַ���ת��Ϊ����
set /a v_number=%var%+0
rem 4.���кϹ��Աȶ�
if %v_number% EQU 0 (
	echo PasswordComplexity�� %v_number% ��δ���ã����Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo PasswordComplexityδ���ã����Ϲ�.>>%v_outpath%\Conviction.out
) else (
	echo PasswordComplexity�� %v_number% ���Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----�鿴PasswordHistorySize�Ƿ�Ϲ�-----
type %v_outpath%\temp.out|find "PasswordHistorySize =" > %v_outpath%\temp2.out
rem 2.������Ϣ��ȥ���ո�.
rem ȥ���ո�
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.���ַ���ת��Ϊ����
set /a v_number=%var%+0
rem 4.���кϹ��Աȶ�
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSWORD_PasswordHistorySize "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_PasswordHistorySize_value=%%i 
if %v_number% NEQ %v_PasswordHistorySize_value% (
	echo PasswordHistorySize�� %v_number% ��������%v_PasswordHistorySize_value%�����Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo PasswordHistorySize������%v_PasswordHistorySize_value%�����Ϲ�.>>%v_outpath%\Conviction.out
) else (
	echo PasswordHistorySize�� %v_number% ���Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem -----�鿴ClearTextPassword�Ƿ�Ϲ�-----
type %v_outpath%\temp.out|find "ClearTextPassword =" > %v_outpath%\temp2.out
rem 2.������Ϣ��ȥ���ո�.
rem ȥ���ո�
for /f "tokens=2 delims==" %%i in ('type %v_outpath%\temp2.out') do (
	set "var=%%i"
	call set "var=%%var:~1%%"
)
rem 3.���ַ���ת��Ϊ����
set /a v_number=%var%+0
rem 4.���кϹ��Աȶ�
if %v_number% EQU 1 (
	echo ClearTextPassword�� %v_number% ���ѿ��������Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo ClearTextPassword�ѿ��������Ϲ�.>>%v_outpath%\Conviction.out
) else (
	echo ClearTextPassword�� %v_number% ���Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSWORD.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_PASSWORD.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out
