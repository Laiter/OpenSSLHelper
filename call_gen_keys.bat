@echo off
(>&2 echo "Generating AES-256")
cd /d %~dp0
cd AES
call Gen_AES_256.bat
cd ..
(>&2 echo "Generating RSA")
cd RSA
call Gen_RSA.bat
cd ..
(>&2 echo "AES_256.hex, PUBLIC_RSA_4096.pem and PRIVATE_RSA_4096.pem in Out/ dir")