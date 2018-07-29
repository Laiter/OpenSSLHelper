@echo off
openssl rand 4096 | openssl dgst -sha256 -r > ..\Out\AES_256.hex
set /p AesKey=<..\Out\AES_256.hex
echo|set /p "x=%AesKey:~0,64%"> ..\Out\AES_256.hex
