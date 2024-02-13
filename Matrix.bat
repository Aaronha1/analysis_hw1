::
:: Author - Aaron Hajaj (ID 311338198)
::
:: This batch file performs calculations on square matrices.
::
:: https://github.com/Aaronha1/analysis_hw1.git
::

@echo off
title %~n0
for /f "tokens=* delims=:" %%i in ('findstr/b :: %0') do echo.%%i
pause

:start
cls
setlocal enabledelayedexpansion
choice /c 123456789 /n /m "Select[1-9] length of matrix(nXn): n="
set/a n=%errorlevel%,n1=n-1,col=row=0
call:m_insert A
set/a col=row=0
call:m_insert B
cls

call:m_print A
call:m_print B

call:m_add A B A+B
call:m_print A+B

call:m_multi A B AxB
call:m_print AxB

call:m_multi B A BxA
call:m_print BxA

endlocal
echo Press any key to run again . . .
pause>nul
goto start


:m_add
for /l %%i in (0,1,%n1%) do (
for /l %%j in (0,1,%n1%) do (
set/a tmp=!%1[%%i][%%j]!+!%2[%%i][%%j]!
set "%3[%%i][%%j]=!tmp!"))
exit/b

:m_multi
for /l %%i in (0,1,%n1%) do (
for /l %%j in (0,1,%n1%) do (set tmp=0
for /l %%k in (0,1,%n1%) do (
set/a a=!%1[%%i][%%k]!,a1=a/10,a2=a%%10
set/a b=!%2[%%k][%%j]!,b1=b/10,b2=b%%10
set/a tmp+=a1*b1+a1*b2/10+a2*b1/10)
set "%3[%%i][%%j]=!tmp!"))
exit/b

:m_insert
cls
echo Enter values of matrix(%n%X%n%): [press 'Enter' after any number]
call:m_print %1
set/p num=||goto m_insert
call:check_num||goto m_insert
if "!num:.=!" neq "!num!" (
for /f "tokens=1,2 delims=." %%a in ("%num%") do (
if "!num:~,1!"=="-" (set op=-) else (set op=+)
set t=%%b&set t1=!t:~,1!&set t2=!t:~1,1!
set/a "tmp=%%a*100 !op! t1*10 !op! t2*1")
) else (set/a tmp=num*100)
set/a %1[%row%][%col%]=tmp+0
set/a col+=1,row+=col/n,col%%=n
if %row% lss %n% goto m_insert
exit/b

:m_print
echo %1:
for /l %%i in (0,1,%n1%) do (
for /l %%j in (0,1,%n1%) do (
if "!%1[%%i][%%j]!" neq "" (
set tmp=!%1[%%i][%%j]!
if "!tmp:~,1!"=="-" (set tmp=!tmp:~1!
set op=-) else (set op=)
if "!tmp:~,-2!"=="" set tmp=0!tmp!
if "!tmp:~,-2!"=="" set tmp=0!tmp!
if !tmp:~-2!==00 (set tmp=!tmp:~,-2!
) else (set tmp=!tmp:~,-2!.!tmp:~-2!)
<nul set/p ".=!op!!tmp! "
) else (exit/b))
echo.&echo.)
exit/b

:check_num
set tmp=%num%9
if "!tmp:~,1!"=="-" set tmp=!tmp:~1!
if "!tmp:~,1!"=="." exit/b 1
for /l %%i in (0,1,9) do set tmp=!tmp:%%i=!
if not defined tmp exit/b 0
if "!tmp!"=="." exit/b 0
echo Wrong input "%tmp%", enter again.
timeout 5
exit/b 1
