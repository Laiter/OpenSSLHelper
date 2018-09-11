set file_extensions=.txt .bin
set new_file_extensions=.txtnew .binnew
set master_keys_dir=MASTER
set master_aes_keys_name=M_AES_1 M_AES_2
set master_rsa_keys_name=M_RSA_1 M_RSA_2
set gen_aes_keys_name=AES_1 AES_2
set gen_rsa_keys_name=RSA_1 RSA_2
set rsa_key_length=4096
set license_file_name=LICENSE_1 LICENSE_2
set license_exp_date_template=date
set license_extensions=.txt
set new_license_extensions=.txtnew
(>&2 echo "-------------------------")
(>&2 echo "settings:")
(>&2 echo "file_extensions = %file_extensions%")
(>&2 echo "new_file_extensions = %new_file_extensions%")
(>&2 echo "master_keys_dir = %master_keys_dir%")
(>&2 echo "master_aes_keys_name = %master_aes_keys_name%")
(>&2 echo "master_rsa_keys_name = %master_rsa_keys_name%")
(>&2 echo "gen_aes_keys_name = %gen_aes_keys_name%")
(>&2 echo "gen_rsa_keys_name = %gen_rsa_keys_name%")
(>&2 echo "rsa_key_length = %rsa_key_length%")
(>&2 echo "license_file_name = %license_file_name%")
(>&2 echo "license_exp_date_template = %license_exp_date_template%")
(>&2 echo "license_extensions = %license_extensions%")
(>&2 echo "new_license_extensions = %new_license_extensions%")
(>&2 echo "------------------------- settings")