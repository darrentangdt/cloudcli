@echo off
rem ************************************************
rem  �ļ�����SECAUD_WIN_NETACC_RES.bat       
rem  ���Թ��������չ�����ȫ����Ⱥ��            
rem  �ű�׫д������������ƽ̨��Ŀ��                               
rem  ��  �ڣ�2014��3��10��                          
rem  ��  �ܣ����ͨ���������ϵͳ���û���Ϣ                                        
rem ************************************************
@echo off
rem �����ʱ�ű����Ŀ¼�Ƿ����
set v_outpath="C:\Program Files\opsware\script\tmp"
if exist %v_outpath% (
	echo nothing > %v_outpath%\temp.out
)else (
	mkdir %v_outpath%
	cd %v_outpath%
)


rem 1.���ͨ���������ϵͳ���û���Ϣ.
secedit /export /cfg %v_outpath%\temp.out >>%v_outpath%\temp1.out
echo **********>%v_outpath%\SECAUD_WIN_NETACC.out
echo ԭʼ��Ϣ��>>%v_outpath%\SECAUD_WIN_NETACC.out
echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
type %v_outpath%\temp.out|find "SeNetworkLogonRight" >>%v_outpath%\SECAUD_WIN_NETACC.out

rem 2.Everyone��Ӧ��ϵͳ����ı��Ϊ��*S-1-1-0��
type %v_outpath%\SECAUD_WIN_NETACC.out|find "*S-1-1-0" >nul
if errorlevel 1 (
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo �м�����>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo �����б��в�����Everyone���Ϲ档>>%v_outpath%\SECAUD_WIN_NETACC.out
)else (
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo �м�����>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo �����б��а���Everyone�����Ϲ档>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo �����б��а���Everyone�����Ϲ档>>%v_outpath%\Conviction.out
)

rem 3.�ó��Ϲ����
if exist %v_outpath%\Conviction.out (
	echo Non-Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo "���Ϲ�" >> %v_outpath%\SECAUD_WIN_NETACC.out
)else (
	echo Compliant
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo ���ս��ۣ�>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo **********>>%v_outpath%\SECAUD_WIN_NETACC.out
	echo "�Ϲ�" >> %v_outpath%\SECAUD_WIN_NETACC.out
)

rem 4.ɾ����ʱ�ļ�.
if exist %v_outpath%\temp.out del %v_outpath%\temp.out
if exist %v_outpath%\temp1.out del %v_outpath%\temp1.out 
if exist %v_outpath%\Conviction.out del %v_outpath%\Conviction.out 