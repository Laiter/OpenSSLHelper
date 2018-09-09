set file_extensions=.txt .bin
set new_file_extensions=.txtnew .binnew
set master_keys_dir=MASTER
set master_aes_keys_name=M_AES_1 M_AES_2
set gen_aes_keys_name=AES_1 AES_2
set gen_rsa_keys_name=RSA_1 RSA_2
set rsa_key_length=4096
(>&2 echo "-------------------------")
(>&2 echo "settings:")
(>&2 echo "file_extensions = %file_extensions%")
(>&2 echo "new_file_extensions = %new_file_extensions%")
(>&2 echo "master_keys_dir = %master_keys_dir%")
(>&2 echo "master_aes_keys_name = %master_aes_keys_name%")
(>&2 echo "gen_aes_keys_name = %gen_aes_keys_name%")
(>&2 echo "gen_rsa_keys_name = %gen_rsa_keys_name%")
(>&2 echo "rsa_key_length = %rsa_key_length%")
(>&2 echo "------------------------- settings")