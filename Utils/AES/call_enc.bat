:: Command line param: 
:: 1 - AES Key HEX File Name
:: 2 - Input File Name
:: Example:
:: call_enc.bat MASTER_AES.hex 00000000000000000000000000000000 input.txt > input.txt.enc
@echo off
(>&2 echo "-------------------------")
(>&2 echo "call_enc:")
(>&2 echo "Operations: 1 - Encrypt AES-256-CBC, 2 - Decrypt AES-256-CBC")
set /p CryptoOperation=
(>&2 echo "AES_KEY = %1")
set /p AES_KEY=<%1
set "IV=%2"
(>&2 echo "IV:%IV% KEY:%AES_KEY%")
IF %CryptoOperation%==1 (
	type %3 | openssl enc -aes-256-cbc -K %AES_KEY% -iv %IV% -e
)
IF %CryptoOperation%==2 (
	type %3 | openssl enc -aes-256-cbc -K %AES_KEY% -iv %IV% -d
)
(>&2 echo "------------------------- call_enc")