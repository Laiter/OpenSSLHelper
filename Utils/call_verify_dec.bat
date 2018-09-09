:: Verify SHA256 with RSA and Decrypt with AES-256-CBC 
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "-------------------------")
(>&2 echo "call_verify_dec:")
set "InputFilePath=%1"
set "NewFileExt=%2"
set "AesKeyName=%3"
set "RsaKeyName=%4"
(>&2 echo "InputFilePath = %1")
(>&2 echo "NewFileExt = %2")
(>&2 echo "AesKeyName = %3")
(>&2 echo "RsaKeyName = %4")
call :NORMALIZEPATH %InputFilePath%
call :DELIMPATH %RETVAL%
set InputFilePath=%RETVAL%
if not exist %InputFilePath% (
(>&2 echo "File %InputFilePath% not found")
(>&2 echo "------------------------- call_verify_dec")
EXIT /B 1
)
if not exist Decrypt mkdir Decrypt
for %%I in (.) do set CurrDirName=%%~nxI
(>&2 echo "..\..\Utils\RSA\call_dgst.bat ..\..\Keys\%CurrDirName%\%RsaKeyName% %InputFilePath%")
echo 2|call ..\..\Utils\RSA\call_dgst.bat ..\..\Keys\%CurrDirName%\%RsaKeyName% %InputFilePath%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, call_dgst.bat error = !errorlevel!")
	(>&2 echo "------------------------- call_verify_dec")
	EXIT /B 1
)
(>&2 echo "..\..\Utils\AES\call_enc.bat ..\..\Keys\%CurrDirName%\%AesKeyName% 00000000000000000000000000000000 %InputFilePath% > Decrypt\%DelimFileName%%NewFileExt%")
echo 2|call ..\..\Utils\AES\call_enc.bat ..\..\Keys\%CurrDirName%\%AesKeyName% 00000000000000000000000000000000 %InputFilePath% > Decrypt\%DelimFileName%%NewFileExt%
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