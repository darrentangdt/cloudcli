@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_CHECKGUEST_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                           
rem  ��  �ܣ����Guest�û��Ƿ���                                      
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ���� 
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

@echo off
rem 1.��ȡGuest�û�����Ϣ
echo ԭʼ��Ϣ>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
net user Guest>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out

rem 2.�ж�ϵͳ���ԣ���֧��Ӣ�ĺ�����.
type %v_outpath%\SECAUD_WIN_CHECKGUEST.out|find "User name" > %v_outpath%\temp.out
if errorlevel 1 (
	set "language=c"
)else (
	set "language=e"
)

rem 3.��ȡ�˻�������Ϣ
setlocal enabledelayedexpansion
rem For Chinese
if %language%==c (
	type %v_outpath%\SECAUD_WIN_CHECKGUEST.out|find "�ʻ�����               Yes"> %v_outpath%\temp.out
	if errorlevel 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest�û�δ�������Ϲ档>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	) else (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest�û����������Ϲ档>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest�û����������Ϲ档>>%v_outpath%\Conviction.out
	)
)

rem For English
if %language%==e (
	type %v_outpath%\SECAUD_WIN_CHECKGUEST.out|find "Account active               Yes"> %v_outpath%\temp.out	
	if errorlevel 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest�û�δ�������Ϲ档>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	) else (
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest�û����������Ϲ档>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
		echo Guest�û����������Ϲ档>>%v_outpath%\Conviction.out
	)
)

rem 4.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_CHECKGUEST.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo **********>>%v_outpath%\SECAUD_WIN_CHECKGUEST.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_CHECKGUEST.out
)

rem 5.ɾ����ʱ�ļ�.
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
if exist %v_outpath%\temp.out del %v_outpath%\temp.out