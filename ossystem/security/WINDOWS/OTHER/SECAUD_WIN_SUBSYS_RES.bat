@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_SUBSYS_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                          
rem  ��  �ܣ������ϵͳ�Ƿ�����POSIX                                    
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡ��ϵͳ��Ϣ��
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_SUBSYS.out
echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out

setlocal enabledelayedexpansion

rem 2.�����ϵͳ�Ƿ�����POSIX
echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_SUBSYS.out
echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Session Manager\SubSystems\optional" >>%v_outpath%\SECAUD_WIN_SUBSYS.out
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo SubSystems\optional�����ڡ����Ϲ�>> %v_outpath%\SECAUD_WIN_SUBSYS.out
	echo SubSystems\optional�����ڡ����Ϲ�>> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע����ֵ���ò��Ϲ�.
	type %v_outpath%\SECAUD_WIN_SUBSYS.out|find "Posix" >%v_outpath%\temp1.out
	if errorlevel 1 (
		echo ��ϵͳδ������Posix���Ϲ�>> %v_outpath%\SECAUD_WIN_SUBSYS.out
	)else (
		echo ��ϵͳ������Posix�����Ϲ�>> %v_outpath%\SECAUD_WIN_SUBSYS.out
		echo ��ϵͳ������Posix�����Ϲ�.>>%v_outpath%\Conviction.out
	)
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_SUBSYS.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo **********>>%v_outpath%\SECAUD_WIN_SUBSYS.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_SUBSYS.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 