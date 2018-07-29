:: Command line param: 
:: 1 - AES Key HEX File Name
:: 2 - Input File Name
:: Example:
:: call.bat MASTER_AES.hex 00000000000000000000000000000000 input.txt > input.txt.enc
@echo off
(>&2 echo "Operations: 1 - Encrypt AES-256-CBC, 2 - Decrypt AES-256-CBC")
set /p CryptoOperation=
call Set_AES_Param.bat %1 %2
(>&2 echo "IV:%IV% KEY:%AES_KEY%")
IF %CryptoOperation%==1 (
    call Encrypt_AES_256_CBC.bat %3 -e
)
IF %CryptoOperation%==2 (
    call Encrypt_AES_256_CBC.bat %3 -d
)