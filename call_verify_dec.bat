:: Encrypt with AES-256-CBC and Sign SHA256 with RSA
:: Result will be in Out/ dir
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "Verify and Decrypt util" & echo."Enter file name in work dir (ex. profile.xml)" & echo."or absolute file path (ex. D:\Profiles\profile.xml):")
set /p "ProfilePath="
(>&2 echo "Enter new file extension (ex. dec):")
set /p "NewProfileExt="
call :NORMALIZEPATH %ProfilePath%
call :DELIMPATH %RETVAL%
set ProfilePath=%RETVAL%
cd /d %~dp0
call set_keys.bat
cd RSA
echo 2|call call_dgst.bat ..\Keys\%RSA_VERIFY_KEY% ..\Out\%ProfileFileName%%ProfileFileExtension%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, error = !errorlevel!")
	EXIT /B 1
)
cd ..
cd AES
echo 2|call call_enc.bat ..\Keys\%AES_ENC_KEY% 00000000000000000000000000000000 %ProfilePath% > ..\Out\%ProfileFileName%.%NewProfileExt%
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