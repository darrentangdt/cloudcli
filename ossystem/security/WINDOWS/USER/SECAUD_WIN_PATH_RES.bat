@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_PATH_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                      
rem  ��  �ܣ����PATH���Ƿ���.                                    
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
rem 1.��ȡPATH��Ϣ
echo ԭʼ��Ϣ>%v_outpath%\SECAUD_WIN_PATH.out
echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
path>>%v_outpath%\SECAUD_WIN_PATH.out

rem 2.���PATH���Ƿ���.
find ";." %v_outpath%\SECAUD_WIN_PATH.out >%v_outpath%\temp.out
if errorlevel 1 (
	find ".;" %v_outpath%\SECAUD_WIN_PATH.out >%v_outpath%\temp.out
	if errorlevel 1 (
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_PATH.out
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo ���PATH�в�����.���Ϲ档>> %v_outpath%\SECAUD_WIN_PATH.out
	)else (
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_PATH.out
		echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
		echo ���PATH�а���.�����Ϲ档>> %v_outpath%\SECAUD_WIN_PATH.out
		echo ���PATH�а���.�����Ϲ档>> %v_outpath%\Conviction.out
	)
)else (
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_PATH.out
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo ���PATH�а���.�����Ϲ档>> %v_outpath%\SECAUD_WIN_PATH.out
	echo ���PATH�а���.�����Ϲ档>> %v_outpath%\Conviction.out
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_PATH.out
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_PATH.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_PATH.out
	echo **********>>%v_outpath%\SECAUD_WIN_PATH.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_PATH.out
)

rem 4.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 

