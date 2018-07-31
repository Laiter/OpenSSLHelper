# OpenSSLHelper
Some win batches to help with OpenSSL AES and RSA encryption
------------------------------------------------------------------
Requirements:
------------------------------------------------------------------
Openssl util https://wiki.openssl.org/index.php/Binaries
Add directory with openssl.exe (ex. C:\openssl\bin or C:\openssl\apps) to Path variable in the Systems Variable

------------------------------------------------------------------
Quick start:
------------------------------------------------------------------
1. Generate AES-256 and RSA 4096 keys with call_gen_key.bat
2. Copy generated keys from Out/ dir to Keys/ dir
3. Run call_enc_sign.bat to encrypt file with AES-256-CBC and sign SHA256 of encrypted file with RSA 
4. Enter file path for encrypt and sign (ex. test.txt or D:\OpenSSLHelper\In\test.txt)
5. Enter out file extension (ex. enc)
6. Get encrypted file and signature in Out/ dir (ex. test.enc and test.enc.sign)
------------------------------------------------------------------
Set up key files
------------------------------------------------------------------
1. Copy keys in Keys/ dir
2. Change key file name variables (AES_ENC_KEY and RSA_SIGN_KEY) in Set_Keys.bat
