[![Price](https://img.shields.io/badge/price-FREE-0098f7.svg)](https://github.com/mkowsiak/FTPDocker/blob/master/LICENSE.md)
[![GitHub](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/mkowsiak/FTPDocker/blob/master/LICENSE.md)
# NetBeans - FTP connection testing Docker image

This Docker based FTP tester helps you setup remote machine with `apache2` and `vsftpd` waiting for NetBeans FTP client to attach (e.g. `PHP Remote Server Project`)

<p align="center">
  <img src="https://github.com/mkowsiak/FTPDocker/blob/master/images/netbeans_ftp.gif?raw=true">
</p>

# Project structure

    .
    |-- Dockerfile                             - Docker file for creating image
    |-- LICENSE.md                             - MIT license file
    |-- README.md                              - this README.md file
    |-- images                                 - sample images show here
    |-- index.php                              - sample PHP application
    |-- start.sh                               - startup script for Docker container
    |-- vsftpd                                 - vsftpd startup script
    |-- vsftpd.conf.explicitssl                - settings for explicit ssl
    |-- vsftpd.conf.implicitssl                - settings for implicit ssl
    `-- vsftpd.conf.nossl                      - settings for no ssl at all
    
# Starting FTP server

## Building FTP/WWW container

    > git clone https://github.com/mkowsiak/FTPDocker
    > cd FTPDocker
    > docker build -t ftptest .

## Running FTP/WWW container - no ssl

    > docker run -i -t \
      -p 80:80 \
      -p 2020:20 \
      -p 2021:21 \
      -p 990:990 \
      -p 21100-21110:21100-21110 \
      ftptest /bin/start.sh no_ssl

## Setting up NetBeans FTP connection - no ssl

<p align="center">
  <img src="https://github.com/mkowsiak/FTPDocker/blob/master/images/no_ssl.png?raw=true">
</p>

## Running FTP/WWW container - explicit ssl

    > docker run -i -t \
      -p 80:80 \
      -p 2020:20 \
      -p 2021:21 \
      -p 990:990 \
      -p 21100-21110:21100-21110 \
      ftptest /bin/start.sh explicit_ssl

## Setting up NetBeans FTP connection - explicit ssl

<p align="center">
  <img src="https://github.com/mkowsiak/FTPDocker/blob/master/images/explicit_ssl.png?raw=true">
</p>

## Running FTP/WWW container - implicit ssl

    > docker run -i -t \
      -p 80:80 \
      -p 2020:20 \
      -p 2021:21 \
      -p 990:990 \
      -p 21100-21110:21100-21110 \
      ftptest /bin/start.sh implicit_ssl

## Setting up NetBeans FTP connection - implicit ssl

<p align="center">
  <img src="https://github.com/mkowsiak/FTPDocker/blob/master/images/implicit_ssl.png?raw=true">
</p>

# Setting up PHP Remote Project

Pick the name of project and location as you like it.

<p align="center">
  <img src="https://github.com/mkowsiak/FTPDocker/blob/master/images/php_settings_1.png?raw=true">
</p>

Make sure to setup project such way it point to `http://localhost:80` and has no `Upload Directory` set.

<p align="center">
  <img src="https://github.com/mkowsiak/FTPDocker/blob/master/images/php_settings_2.png?raw=true">
</p>

# Known limitations

At the moment, FTPDocker has lots of assumptions related to FTP configuration (fixed ports, fixed user name, fixed ftp directory, fixed password, etc.). You can still customize it inside startup script and inside `Dockerfile`.

