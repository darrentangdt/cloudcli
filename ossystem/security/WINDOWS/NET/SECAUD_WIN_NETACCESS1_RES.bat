@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_NETACCESS_RES1.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                          
rem  ��  �ܣ����������ʵ�����                                            
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

rem 1.��ȡ���������Ϣ.
echo ԭʼ��Ϣ:>%v_outpath%\SECAUD_WIN_NETACCESS1.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
secedit /export /cfg %v_outpath%\temp.out >%v_outpath%\temp1.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\DisableDomainCreds" >>%v_outpath%\SECAUD_WIN_NETACCESS1.out
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous" >>%v_outpath%\SECAUD_WIN_NETACCESS1.out

setlocal enabledelayedexpansion

echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
echo �м���ۣ�>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out

rem -----DisableDomainCreds-----
set "flag=0"
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\DisableDomainCreds" > %v_outpath%\temp1.out
rem 2.��ȡ��Ч��Ϣ
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo DisableDomainCredsע�������ڡ����Ϲ� >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo DisableDomainCredsע�������ڡ����Ϲ� >> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע����ֵ���ò��Ϲ�.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp1.out') do (
		set "var=%%i"
	)
	rem 4.���ַ���ת��Ϊ����.
	set /a v_number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !v_number! NEQ 1 (
		echo DisableDomainCreds���Ϲ�. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
		echo DisableDomainCreds���Ϲ�. >> %v_outpath%\Conviction.out
	) else (
		echo DisableDomainCreds�Ϲ�. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	)
)

rem -----EveryoneIncludesAnonymous-----
set "flag=0"
type %v_outpath%\temp.out|find "MACHINE\System\CurrentControlSet\Control\Lsa\EveryoneIncludesAnonymous" > %v_outpath%\temp1.out
rem 2.��ȡ��Ч��Ϣ
if errorlevel 1 (
	rem 3.���1,δ�ҵ���Ӧ��ע�����
	echo EveryoneIncludesAnonymousע�������ڡ����Ϲ� >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo EveryoneIncludesAnonymousע�������ڡ����Ϲ� >> %v_outpath%\Conviction.out
) else (
	rem 3.���2,ע����ֵ���ò��Ϲ�.
	for /f "tokens=2 delims=," %%i in ('type %v_outpath%\temp1.out') do (
		set "var=%%i"
	)
	rem 4.���ַ���ת��Ϊ����.
	set /a v_number=!var!+0
	set "flag=1"
)
if %flag%==1 (
	rem 5.����Ƿ�Ϲ�.
	if !v_number! NEQ 0 (
		echo EveryoneIncludesAnonymous���Ϲ�. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
		echo EveryoneIncludesAnonymous���Ϲ�. >> %v_outpath%\Conviction.out
	) else (
		echo EveryoneIncludesAnonymous�Ϲ�. >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
	)
)

rem 5.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACCESS1.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_NETACCESS1.out
)

rem 6.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 