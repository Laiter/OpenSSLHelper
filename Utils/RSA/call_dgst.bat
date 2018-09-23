:: Command line param: 
:: 1 - RSA Key File Name
:: 2 - Input File Name
:: Example Sign:
:: call_dgst.bat key.pem input.txt
:: Example Verify:
:: call_dgst.bat key_public.pem input.txt
@echo off
setlocal EnableDelayedExpansion
(>&2 echo "-------------------------")
(>&2 echo "call_dgst:")
(>&2 echo "Operations: 1 - Sign SHA256, 2 - Verify SHA256")
set /p CryptoOperation=
IF %CryptoOperation%==1 (
	(>&2 echo "call %~dp0\SingVerify_RSA.bat %2 -sign %1 -out %2.SIGN")
    call %~dp0\SingVerify_RSA.bat %2 -sign %1 -out %2.sign
	(>&2 echo "------------------------- call_dgst")
	EXIT /B !errorlevel!
)
IF %CryptoOperation%==2 (
	(>&2 echo "call %~dp0\SingVerify_RSA.bat %2 -verify %1 -signature %2.sign")
    call %~dp0\SingVerify_RSA.bat %2 -verify %1 -signature %2.sign
	(>&2 echo "------------------------- call_dgst")
	EXIT /B !errorlevel!
)
(>&2 echo "------------------------- call_dgst")
EXIT /B 1