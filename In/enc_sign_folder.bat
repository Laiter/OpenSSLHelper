:: For all xml files in current (In/) dir
:: Encrypt with AES-256-CBC and Sign SHA256 with RSA
:: Result will be in Out/ dir
@echo off
for  %%f in (*.xml) do ( 
   echo Work with %%f 
   cd ..
   call call_enc_sign_ep.bat %%f
   cd In
)
pause