@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_SHUTDOWN_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                           
rem  ��  �ܣ����ػ����������ڴ�ҳ���ļ�����                                             
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


rem 1.��ȡ�ػ����������ڴ�ҳ���ļ����á�
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
secedit /export /cfg %v_outpath%\temp.out > %v_outpath%\temp1.out

setlocal enabledelayedexpansion

rem 2.���ػ����������ڴ�ҳ���ļ�����
set "flag=0"
echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Session Manager\Memory Management\ClearPageFileAtShutdown" >>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo ClearPageFileAtShutdown�����ڡ����Ϲ�>> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo ClearPageFileAtShutdown�����ڡ����Ϲ�>> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע����ֵ���ò��Ϲ�.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\SECAUD_WIN_SHUTDOWN.out') do (
		set "var=%%i"
	)
	rem 4.���ַ���ת��Ϊ����.
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !number! NEQ 1 (
		echo ClearPageFileAtShutdown��ֵ���ò��Ϲ�.>> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
		echo ClearPageFileAtShutdown��ֵ���ò��Ϲ�.>%v_outpath%\Conviction.out
	)else (
		echo ClearPageFileAtShutdown��ֵ���úϹ�.>> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
	)
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo **********>>%v_outpath%\SECAUD_WIN_SHUTDOWN.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_SHUTDOWN.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out