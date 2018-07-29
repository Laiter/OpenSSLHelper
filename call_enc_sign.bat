:: Encrypt with AES-256-CBC and Sign SHA256 with RSA
:: Result will be in Out/ dir
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "Encrypt and sign util" & echo."Enter file name in work dir (ex. profile.xml)" & echo."or absolute file path (ex. D:\Profiles\profile.xml):")
set /p "ProfilePath="
(>&2 echo "Enter new file extension (ex. enc):")
set /p "NewProfileExt="
call :NORMALIZEPATH %ProfilePath%
call :DELIMPATH %RETVAL%
set ProfilePath=%RETVAL%
cd /d %~dp0
call set_keys.bat
cd AES
echo 1|call call_enc.bat ..\Keys\%AES_ENC_KEY% 00000000000000000000000000000000 %ProfilePath% > ..\Out\%ProfileFileName%.%NewProfileExt%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, error = !errorlevel!")
	EXIT /B 1
)
cd ..
cd RSA
echo 1|call call_dgst.bat ..\Keys\%RSA_SIGN_KEY% ..\Out\%ProfileFileName%.%NewProfileExt%
cd ..

:: ========== FUNCTIONS ==========
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B
  
:DELIMPATH
  FOR %%i IN ("%~1") DO (
    SET ProfileFileDrive=%%~di
    SET ProfileFileName=%%~ni
    SET ProfileFilePath=%%~pi
    SET ProfileFileExtension=%%~xi
  )
  EXIT /B