@echo off&&setlocal EnableDelayedExpansion
rem ************************************************
rem  �ļ�����SECAUD_WIN_SERVICES_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                            
rem  ��  �ܣ��������״��                                              
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
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_SERVICES.out
echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
sc queryex >>%v_outpath%\temp.out

for /f "tokens=2,3  delims=|" %%i in ('findstr SECK "%v_golbalpath%\WINDOWS_SEC_PARA.txt"') do (
set v_svrdname=%%i
set v_svrname=%%j
type %v_outpath%\temp.out|find "!v_svrdname!" >>%v_outpath%\temp1.out
if !errorlevel! equ 1 (
	echo !v_svrdname!δ����,�Ϲ�. >> %v_outpath%\SECAUD_WIN_SERVICES.out
) else (
	echo !v_svrdname!�����У����Ϲ�. >> %v_outpath%\SECAUD_WIN_SERVICES.out
	echo !v_svrdname!�����У����Ϲ�. >> %v_outpath%\Conviction.out
)

sc qc !v_svrname!|find "AUTO_START" >>%v_outpath%\temp2.out

if !errorlevel! equ 0 (
	echo !v_svrdname!����Ϊ�Զ�����,���Ϲ�. >> %v_outpath%\SECAUD_WIN_SERVICES.out
) else (
	echo !v_svrdname!���÷��Զ�����,�Ϲ�. >> %v_outpath%\SECAUD_WIN_SERVICES.out
	echo !v_svrdname!���÷��Զ�����,�Ϲ�. >> %v_outpath%\Conviction.out
)
)
rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_SERVICES.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo **********>>%v_outpath%\SECAUD_WIN_SERVICES.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_SERVICES.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out 
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\temp2.out del %v_outpath%\temp2.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 
