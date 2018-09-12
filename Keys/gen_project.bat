@echo off
setlocal EnableDelayedExpansion
cd /d %~dp0
call ..\Utils\settings.bat
(>&2 echo "Enter project name:")
set /p "project_name="
:: check Master dir
if not exist %master_keys_dir% (
	(>&2 echo "Directory %master_keys_dir% not exists")
	EXIT /B 1
)
for %%k in (%master_aes_keys_name%) do (
	if not exist %master_keys_dir%\%%k.hex (
		(>&2 echo "Key %master_keys_dir%\%%k.hex not exists")
		EXIT /B 1
	)
)
:: check Keys dir
if exist !project_name! (
	(>&2 echo "Directory Keys\!project_name! already exists")
	EXIT /B 1
)
:: check Files dir
if exist ..\Files\!project_name! (
	(>&2 echo "Directory Files\!project_name! already exists")
	EXIT /B 1
)
:: create dirs
if not exist !project_name! mkdir !project_name!
if not exist ..\Files\!project_name! mkdir ..\Files\!project_name!
:: create keys
set /A gen_key_num=1
set /A master_key_num=1
(>&2 echo "Generating AES-256")
for %%f in (%gen_aes_keys_name%) do (
	(>&2 echo "Work with %%f")  
	(>&2 echo "..\Utils\AES\Gen_AES_256.bat !project_name!\%%f") 
	call ..\Utils\AES\Gen_AES_256.bat !project_name!\%%f
	if not !errorlevel!==0 (
		(>&2 echo "stop, Gen_AES_256.bat error")
		EXIT /B !errorlevel!
	)
	set /A master_key_num=1 
	for %%k in (%master_aes_keys_name%) do (
		if !gen_key_num! EQU !master_key_num! (>&2 echo "(%%f)%%k = CRYPTOGRAM_!gen_key_num!.BIN")
		if !gen_key_num! EQU !master_key_num! echo 1|call ..\Utils\AES\call_enc.bat %master_keys_dir%\%%k.hex 00000000000000000000000000000000 !project_name!\%%f.bin > !project_name!\CRYPTOGRAM_!gen_key_num!.BIN
		set /A master_key_num=master_key_num+1
		)
	set /A gen_key_num=gen_key_num+1
)
(>&2 echo "Generating RSA")
for %%f in (%gen_rsa_keys_name%) do (
	(>&2 echo "Work with %%f")  
	(>&2 echo "..\Utils\RSA\Gen_RSA.bat !project_name!\%%f %rsa_key_length%")
	call ..\Utils\RSA\Gen_RSA.bat !project_name!\%%f %rsa_key_length%
	if not !errorlevel!==0 (
		(>&2 echo "stop, Gen_RSA.bat error")
		EXIT /B !errorlevel!
	)
)
:: copy Encrypt\Decrypt bat files
(>&2 echo "xcopy /s ..\Utils\template ..\Files\!project_name!")
xcopy /s ..\Utils\template ..\Files\!project_name!
if not !errorlevel!==0 (
	(>&2 echo "xcopy error !errorlevel!")
	EXIT /B !errorlevel!
)
:: create license
(>&2 echo "gen_license.bat")
call gen_license.bat
if not !errorlevel!==0 (
	(>&2 echo "get_license.bat error !errorlevel!")
	EXIT /B !errorlevel!
)
EXIT /B