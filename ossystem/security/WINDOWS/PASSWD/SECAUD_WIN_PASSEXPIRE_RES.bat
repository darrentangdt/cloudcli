@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_PASSEXPIRE_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                        
rem  ��  �ܣ�������뵽����ʾ�Ƿ���                                      
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

rem 1.��ȡ���뵽����ʾ��Ϣ
echo ԭʼ��Ϣ>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out

rem 2.������뵽����ʾ�Ƿ���.
type %v_outpath%\temp.out|find "PasswordExpiryWarning=" >%v_outpath%\temp1.out
type %v_outpath%\temp.out|find "PasswordExpiryWarning=" >>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
rem 2.������Ϣ��ȥ���ո�.
for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp1.out') do (
	set "var=%%i"
)
rem 3.���ַ���ת��Ϊ����
set /a v_number=%var%+0
rem 4.���кϹ��Աȶ�
for /f "tokens=2  delims==" %%i in ('findstr V_WINODWS_SEC_PASSEXPIRE_PasswordExpiryWarning "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do set v_PasswordExpiryWarning_value=%%i 
if %v_number% LSS %v_PasswordExpiryWarning_value% (
	echo PasswordExpiryWarningС��%v_PasswordExpiryWarning_value%�����Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo PasswordExpiryWarningС��%v_PasswordExpiryWarning_value%�����Ϲ�.>>%v_outpath%\Conviction.out
) else (
	echo PasswordExpiryWarningΪ%v_number%���Ϲ�.>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
)

rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_PASSEXPIRE.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo **********>>%v_outpath%\SECAUD_WIN_PASSEXPIRE.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_PASSEXPIRE.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 