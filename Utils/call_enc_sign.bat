:: Encrypt with AES-256-CBC and Sign SHA256 with RSA
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "-------------------------")
(>&2 echo "call_enc_sign:")
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
(>&2 echo "------------------------- call_enc_sign")
EXIT /B 1
)
if not exist Encrypt mkdir Encrypt
for %%I in (.) do set CurrDirName=%%~nxI
(>&2 echo "..\..\Utils\AES\call_enc.bat ..\..\Keys\%CurrDirName%\%AesKeyName% 00000000000000000000000000000000 %InputFilePath% > Encrypt\%DelimFileName%%NewFileExt%")
echo 1|call ..\..\Utils\AES\call_enc.bat ..\..\Keys\%CurrDirName%\%AesKeyName% 00000000000000000000000000000000 %InputFilePath% > Encrypt\%DelimFileName%%NewFileExt%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, call_enc.bat error = !errorlevel!")
	(>&2 echo "------------------------- call_enc_sign")
	EXIT /B 1
)
(>&2 echo "..\..\Utils\RSA\call_dgst.bat ..\..\Keys\%CurrDirName%\%RsaKeyName% Decrypt\%DelimFileName%%NewFileExt%")
echo 1|call ..\..\Utils\RSA\call_dgst.bat ..\..\Keys\%CurrDirName%\%RsaKeyName% Encrypt\%DelimFileName%%NewFileExt%
IF NOT !errorlevel!==0 (
	(>&2 echo "stop, call_dgst.bat error = !errorlevel!")
	(>&2 echo "------------------------- call_enc_sign")
	EXIT /B 1
)

:: ========== FUNCTIONS ==========
(>&2 echo "------------------------- call_enc_sign")
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