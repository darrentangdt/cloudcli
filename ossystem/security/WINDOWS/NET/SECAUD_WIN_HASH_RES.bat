@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_HASH_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                            
rem  ��  �ܣ����LAN Manager�Ĺ�ϣֵ����                                             
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


rem 1.��ȡLAN MANAGER�Ĺ�ϣֵ���á�
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_HASH.out
echo **********>>%v_outpath%\SECAUD_WIN_HASH.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out

setlocal enabledelayedexpansion

rem 2.���LAN Manager�Ĺ�ϣֵ����
set "flag=0"
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\NoLMHash" >>%v_outpath%\SECAUD_WIN_HASH.out
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo NoLMHash�����ڡ����Ϲ�>> %v_outpath%\SECAUD_WIN_HASH.out
	echo NoLMHash�����ڡ����Ϲ�>> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע����ֵ���ò��Ϲ�.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\SECAUD_WIN_HASH.out') do (
		set "var=%%i"
	)
	rem 4.���ַ���ת��Ϊ����.
	set /a v_number=!var!+0
	set "flag=1"
)

if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !v_number! NEQ 1 (
		echo NoLMHash��ֵ���ò��Ϲ�.>> %v_outpath%\SECAUD_WIN_HASH.out
		echo NoLMHash��ֵ���ò��Ϲ�.>> %v_outpath%\Conviction.out
	)else (
		echo NoLMHash��ֵ���úϹ�.>> %v_outpath%\SECAUD_WIN_HASH.out
	)
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_HASH.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_HASH.out
	echo **********>>%v_outpath%\SECAUD_WIN_HASH.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_HASH.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_HASH.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_HASH.out
	echo **********>>%v_outpath%\SECAUD_WIN_HASH.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_HASH.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out 
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out