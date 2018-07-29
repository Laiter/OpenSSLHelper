@echo off
(>&2 echo "Enter key length (ex. 4096):")
set /p "RsaKeyLength="
openssl genrsa -out ..\Out\PRIVATE_RSA_%RsaKeyLength%.pem %RsaKeyLength%
openssl rsa -in ..\Out\PRIVATE_RSA_%RsaKeyLength%.pem -pubout > ..\Out\PUBLIC_RSA_%RsaKeyLength%.pem