@echo off&&setlocal EnableDelayedExpansion

rem ************************************************
rem  �ļ�����SECAUD_WIN_AUTOLOGON_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                              
rem  ��  �ܣ�����Զ���¼������                                               
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡ�Զ���¼��Ϣ.
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
reg query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon" /s >>%v_outpath%\SECAUD_WIN_AUTOLOGON.out 2>&1
if !errorlevel! equ 1 (
	rem 3.ע�������ڣ��Ϲ�
	echo AutoAdminLogonע�������ڣ��Ϲ�>> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
) else (
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out

	type %v_outpath%\SECAUD_WIN_AUTOLOGON.out|find /I "AutoAdminLogon    REG_SZ    1" > %v_outpath%\temp.out
	rem 2.��ȡ��Ч��Ϣ.
	if !errorlevel! equ 0 (
		rem 3.ע�����Ϲ�
		echo AutoAdminLogonע�����Ϲ�>> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
		echo AutoAdminLogonע�����Ϲ�> %v_outpath%\Conviction.out
	) else (
		echo AutoAdminLogonע�����Ϲ�>> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
	)
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo **********>>%v_outpath%\SECAUD_WIN_AUTOLOGON.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_AUTOLOGON.out
)

rem 4.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out