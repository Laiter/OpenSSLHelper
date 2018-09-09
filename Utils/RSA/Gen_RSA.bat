@echo off
openssl genrsa -out %1_PRIV.PEM %2
openssl rsa -in %1_PRIV.PEM -pubout > %1_PUB.PEM