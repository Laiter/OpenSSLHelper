@echo off
openssl rand 4096 | openssl dgst -sha256 -r > %1.hex
set /p AesKey=<%1.hex
echo|set /p "x=%AesKey:~0,64%"> %1.hex
certutil -f -decodehex %1.hex %1.bin