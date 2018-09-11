:: Verify SHA256 with RSA and Decrypt with AES-256-CBC 
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "-------------------------")
(>&2 echo "call_verify_dec:")
set "InputFilePath=%1"
set "NewFileExt=%2"
set "AesKeyPath=%3"
set "RsaKeyPath=%4"
set "OutDirPath=%5"
(>&2 echo "InputFilePath = %1")
(>&2 echo "NewFileExt = %2")
(>&2 echo "AesKeyPath = %3")
(>&2 echo "RsaKeyPath = %4")
(>&2 echo "OutDirPath = %5")
call :NORMALIZEPATH %InputFilePath%
call :DELIMPATH %RETVAL%
set InputFilePath=%RETVAL%
if not exist %InputFilePath% (
(>&2 echo "File %InputFilePath% not found")
(>&2 echo "------------------------- call_verify_dec")
EXIT /B 1
)
if not exist %OutDirPath% mkdir %OutDirPath%
(>&2 echo "%~dp0\RSA\call_dgst.bat %RsaKeyPath% %InputFilePath%")
echo 2|call %~dp0\RSA\call_dgst.bat %RsaKeyPath% %InputFilePath%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, call_dgst.bat error = !errorlevel!")
	(>&2 echo "------------------------- call_verify_dec")
	EXIT /B 1
)
(>&2 echo "%~dp0\AES\call_enc.bat %AesKeyPath% 00000000000000000000000000000000 %InputFilePath% > %OutDirPath%\%DelimFileName%%NewFileExt%")
echo 2|call %~dp0\AES\call_enc.bat %AesKeyPath% 00000000000000000000000000000000 %InputFilePath% > %OutDirPath%\%DelimFileName%%NewFileExt%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, call_enc.bat error = !errorlevel!")
	(>&2 echo "------------------------- call_verify_dec")
	EXIT /B 1
)

:: ========== FUNCTIONS ==========
(>&2 echo "------------------------- call_verify_dec")
EXIT /B

:NORMALIZEPATH
  SET RETVAL=%~dpfn1
  EXIT /B
  
:DELIMPATH
  FOR %%i IN ("%~1") DO (
    SET DelimFileDrive=%%~di
    SET DelimFileName=%%~ni
    SET DelimFilePath=%%~pi
    SET DelimFileExtension=%%~xi
  )
  EXIT /B