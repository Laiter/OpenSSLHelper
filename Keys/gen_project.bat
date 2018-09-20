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
	goto ZipDeploy
)
:: check Files dir
if exist ..\Files\!project_name! (
	(>&2 echo "Directory Files\!project_name! already exists")
	EXIT /B 1
)
:: ============================
:: create dirs
if not exist !project_name! mkdir !project_name!
if not exist ..\Files\!project_name! mkdir ..\Files\!project_name!
:: create AES keys
set /A gen_key_num=1
set /A master_key_num=1
(>&2 echo "Generating AES-256")
for %%f in (%gen_aes_keys_name%) do (
	(>&2 echo "Work with %%f")  
	(>&2 echo "..\Utils\AES\Gen_AES_256.bat !project_name!\%%f") 
	call ..\Utils\AES\Gen_AES_256.bat !project_name!\%%f
	if not !errorlevel!==0 (
		(>&2 echo "stop, Gen_AES_256.bat error")
		call :Clean
		EXIT /B !errorlevel!
	)
	set /A master_key_num=1 
	for %%k in (%master_aes_keys_name%) do (
		if !gen_key_num! EQU !master_key_num! (>&2 echo "(%%f)%%k = CRYPTOGRAM_!gen_key_num!.BIN")
		if !gen_key_num! EQU !master_key_num! echo 1|call ..\Utils\AES\call_enc.bat %master_keys_dir%\%%k.hex 00000000000000000000000000000000 !project_name!\%%f.bin > !project_name!\CRYPTOGRAM_!gen_key_num!.BIN
		if not !errorlevel!==0 (
			(>&2 echo "stop, call_enc.bat error !errorlevel!")
			call :Clean
			EXIT /B !errorlevel!
		)
		set /A master_key_num=master_key_num+1
	)
	set /A gen_key_num=gen_key_num+1
)
:: create RSA keys
set /A gen_key_num=1
set /A master_key_num=1
(>&2 echo "Generating RSA")
for %%f in (%gen_rsa_keys_name%) do (
	(>&2 echo "Work with %%f")  
	(>&2 echo "..\Utils\RSA\Gen_RSA.bat !project_name!\%%f %rsa_key_length%")
	call ..\Utils\RSA\Gen_RSA.bat !project_name!\%%f %rsa_key_length%
	if not !errorlevel!==0 (
		(>&2 echo "stop, Gen_RSA.bat error !errorlevel!")
		call :Clean
		EXIT /B !errorlevel!
	)
	set /A master_key_num=1 
	for %%k in (%master_rsa_keys_name%) do (
		if !gen_key_num! EQU !master_key_num! (>&2 echo "..\Utils\RSA\call_dgst.bat %master_keys_dir%\%%k_PRIV.PEM !project_name!\%%f_PUB.PEM")
		if !gen_key_num! EQU !master_key_num! echo 1|call ..\Utils\RSA\call_dgst.bat %master_keys_dir%\%%k_PRIV.PEM !project_name!\%%f_PUB.PEM
		if not !errorlevel!==0 (
			(>&2 echo "stop, call_dgst.bat error = !errorlevel!")
			call :Clean
			EXIT /B !errorlevel!
		)
		set /A master_key_num=master_key_num+1
	)
	set /A gen_key_num=gen_key_num+1
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
	call :Clean
	EXIT /B !errorlevel!
)
:: zip deploy
call :ZipDeploy
if not !errorlevel!==0 (
	(>&2 echo "ZipDeploy error !errorlevel!")
	call :Clean
	EXIT /B !errorlevel!
)
:: ========== FUNCTIONS ==========
EXIT /B

:ZipDeploy
cd %project_name%
if not "%deploy_zip_password%"=="" (
	(>&2 echo "Password exists %deploy_zip_password%")
	set zip_password_option=-p%deploy_zip_password%
)
for %%d in (..\..\Utils\deploy\*.txt) do (
	if exist %%~nd.zip (
		(>&2 echo "delete %%~nd.zip")
		del %%~nd.zip
	) 
	(>&2 echo "7z a -tzip %%~nd.zip @%%d %zip_password_option%")
	7z a -tzip %%~nd.zip @%%d %zip_password_option%
	if not !errorlevel!==0 (
		(>&2 echo "7z error !errorlevel!")
		EXIT /B !errorlevel!
	)
)
cd ..
EXIT /B

:Clean
(>&2 echo "Cleaning...")
cd /d %~dp0
if exist !project_name! (
	(>&2 echo "delete dir !project_name!")
	rmdir /s !project_name!
) 
if exist ..\Files\!project_name! (
	(>&2 echo "delete dir ..\Files\!project_name!")
	rmdir /s ..\Files\!project_name!
) 
EXIT /B