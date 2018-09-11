@echo off
setlocal EnableDelayedExpansion
cd /d %~dp0
(>&2 echo "-------------------------")
(>&2 echo "Encrypt:")
call ..\..\Utils\settings.bat
set /A extension_num=1
set /A new_extension_num=1
set /A key_num=1
set current_aes_key_name=key
set current_rsa_key_name=key
for %%I in (.) do set CurrDirName=%%~nxI
for  %%e in (%file_extensions%) do (
	set /A new_extension_num=1
	for %%n in (%new_file_extensions%) do (
		if !extension_num! EQU !new_extension_num! (
			(>&2 echo "%%e -> %%n")
			set /A key_num=1
			for %%a in (%gen_aes_keys_name%) do (
				if !extension_num! EQU !key_num! (
					(>&2 echo "current_aes_key_name = %%a")
					set current_aes_key_name=%%a
				)
				set /A key_num=key_num+1
			)
			set /A key_num=1
			for %%r in (%gen_rsa_keys_name%) do (
				if !extension_num! EQU !key_num! (
					(>&2 echo "current_rsa_key_name = %%r")
					set current_rsa_key_name=%%r
				)
				set /A key_num=key_num+1
			)
			for %%f in (*%%e) do (
				(>&2 echo "call_enc_sign.bat %%f %%n ..\..\Keys\%CurrDirName%\!current_aes_key_name!.hex ..\..\Keys\%CurrDirName%\!current_rsa_key_name!_PRIV.pem Encrypt")
				call ..\..\Utils\call_enc_sign.bat %%f %%n ..\..\Keys\%CurrDirName%\!current_aes_key_name!.hex ..\..\Keys\%CurrDirName%\!current_rsa_key_name!_PRIV.pem Encrypt
				if not !errorlevel!==0 (
					(>&2 echo "call_enc_sign.bat error = !errorlevel!")
				)
				if !errorlevel!==0 (
					(>&2 echo "delete %%f")
					del %%f
				)
			)
		)
		set /A new_extension_num=new_extension_num+1
	)
	set /A extension_num=extension_num+1
)
(>&2 echo "------------------------- Encrypt")
EXIT /B