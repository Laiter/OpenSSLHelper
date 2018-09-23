# OpenSSLHelper

Some win batches to help with OpenSSL AES and RSA encryption

## Requirements

* [Openssl](https://wiki.openssl.org/index.php/Binaries)
* [7z](https://www.7-zip.org/download.html)

## Deployment

* install Openssl and 7z
* add to Path system variable:
** openssl.exe dir (ex. C:\openssl\bin, C:\openssl\apps)
** 7z.exe dir (ex. C:\Program Files\7-Zip)

## How to use

* Configure Utils\settings.bat
* Configure Utils\deploy\*.txt
* Add master keys to Keys\MASTER
* Create project with Keys\gen_project.bat (directories with project name will be created in Keys and Files dirs)
** Enter project name (ex. project1) 
** Enter license expiration date (ex. 01.01.2020)
* (if needed)re-create license files with Keys\gen_license.bat
* (if needed)re-create deploy zip with Keys\gen_project.bat
* Copy files to "Files\project dir" for encrypt\decrypt (ex. Files\project1)
* Use "Files\project dir\Encrypt.bat" to encrypt files in project dir (ex. Files\project1\Encrypt.bat)
* Use "Files\project dir\Decrypt.bat" to decrypt files in project dir (ex. Files\project1\Decrypt.bat)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details