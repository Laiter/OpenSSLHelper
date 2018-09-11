@echo off
setlocal EnableDelayedExpansion
cd /d %~dp0
(>&2 echo "-------------------------")
(>&2 echo "gen_license:")
call ..\Utils\settings.bat
(>&2 echo "Enter project name:")
set /p "project_name="
for %%l in (%license_file_name%) do (
	(>&2 echo "Enter license expiration date dd.MM.yyyy format (01.08.2018):")
	set /p exp_date=
	call :checkDate !exp_date!
	if not !errorlevel!==0 EXIT /B 1
	echo %license_exp_date_template%=!exp_date! > %%l.txt
)
(>&2 echo "Encrypt license")
set /A extension_num=1
set /A new_extension_num=1
set /A key_num=1
set current_aes_key_name=key
set current_rsa_key_name=key
for  %%e in (%license_extensions%) do (
	(>&2 echo "license_extensions=%%e")
	set /A new_extension_num=1
	for %%n in (%new_license_extensions%) do (
		(>&2 echo "new_license_extensions=%%n")
		if !extension_num! EQU !new_extension_num! (
			(>&2 echo "%%e -> %%n")
			set /A key_num=1
			for %%a in (%master_aes_keys_name%) do (
				if !extension_num! EQU !key_num! (
					(>&2 echo "current_aes_key_name = %%a")
					set current_aes_key_name=%%a
				)
				set /A key_num=key_num+1
			)
			set /A key_num=1
			for %%r in (%master_rsa_keys_name%) do (
				if !extension_num! EQU !key_num! (
					(>&2 echo "current_rsa_key_name = %%r")
					set current_rsa_key_name=%%r
				)
				set /A key_num=key_num+1
			)
			for %%f in (*%%e) do (
				(>&2 echo "call_enc_sign.bat %%f %%n %master_keys_dir%\!current_aes_key_name!.hex %master_keys_dir%\!current_rsa_key_name!_PRIV.pem %project_name%")
				call ..\Utils\call_enc_sign.bat %%f %%n %master_keys_dir%\!current_aes_key_name!.hex %master_keys_dir%\!current_rsa_key_name!_PRIV.pem %project_name%
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
:: ========== FUNCTIONS ==========
(>&2 echo "------------------------- gen_license")
EXIT /B

:checkDate
set i=0
for %%a in (31 28 31 30 31 30 31 31 30 31 30 31) do (
   set /A i+=1
   set dpm[!i!]=%%a
)
set inDate=%1
if "%inDate:~2,1%%inDate:~5,1%" neq ".." goto invalidDate
for /F "tokens=1-3 delims=." %%a in ("%inDate%") do set "DD=%%a" & set "MM=%%b" & set "YYYY=%%c"
ver > NUL
set /A month=1%MM%-100, day=1%DD%-100, year=1%YYYY%-10000, leap=year%%4  2>NUL
if errorlevel 1 goto invalidDate
if not defined dpm[%month%] goto invalidDate
if %leap% equ 0 set dpm[2]=29
if %day% gtr !dpm[%month%]! goto invalidDate
if %day% lss 1 goto invalidDate
(>&2 echo "Date correct: %DD%.%MM%.%YYYY%")
EXIT /B

:invalidDate
(>&2 echo "bad date")
EXIT /B 1

