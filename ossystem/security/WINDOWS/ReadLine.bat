@echo off&SetLocal ENABLEDELAYEDEXPANSION

set file=%~s1
set first="skip=%2 delims=: tokens=1*"
set last=%3
set loop=0
for /f %first% %%a in ('findstr/n .* %file%') do (
        if not defined lxmxn (echo/%%b&set /a loop+=1) else (goto :EOF)
        if "!loop!"=="%last%" set lxmxn=Nothing
)
GOTO :EOF

:--help
echo/======================================
echo/本程序段需要带参数才能正常运行
echo/&echo/Usage:&echo/Call ReadLine ^<文件名^> ^<跳过行数^> ^<读取行数^>
echo/&echo/例如：call ReadLine aa.txt 5 7 ，将跳过aa.txt文件的前5行，读取下面的7行字符
echo/&echo/如果^<跳过行数^>没有指定，就从文件第一行读取
echo/&echo/指定^<读取行数^>时必须指定^<跳过行^>
echo/======================================
goto :eof