@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_CDROM_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                            
rem  ��  �ܣ����CDROM������                                              
rem ************************************************

rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)

rem 1.��ȡCDROM��Ϣ.
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_CDROM.out
echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
secedit /export /cfg %v_outpath%\SECAUD_WIN_CDROM.out > %v_outpath%\temp.out

setlocal enabledelayedexpansion


echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_CDROM.out
echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
set "flag=0"
type %v_outpath%\SECAUD_WIN_CDROM.out|find "MACHINE\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\AllocateCDRoms" > %v_outpath%\temp.out 2>&1
rem 2.��ȡ��Ч��Ϣ.
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo AllocateCDRomsע�������ڡ����Ϲ�>> %v_outpath%\SECAUD_WIN_CDROM.out
	echo AllocateCDRomsע�������ڡ����Ϲ�>> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע����ֵ���ò��Ϲ�.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp.out') do (
		set "var=%%i"
	)
	rem 4.���ַ���ת��Ϊ����.
	set /a number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !number! NEQ 1 (
		echo AllocateCDRoms��ֵ���ò��Ϲ�.>> %v_outpath%\SECAUD_WIN_CDROM.out
		echo AllocateCDRoms��ֵ���ò��Ϲ�.>> %v_outpath%\Conviction.out
	) else (
		echo AllocateCDRoms�Ϲ�.>> %v_outpath%\SECAUD_WIN_CDROM.out
	)
)
rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_CDROM.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo **********>>%v_outpath%\SECAUD_WIN_CDROM.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_CDROM.out
)
rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 