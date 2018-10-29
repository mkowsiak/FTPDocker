#!/bin/bash

/etc/init.d/apache2 start

FTP_SERVER_ADDRESS=`/sbin/ip route|awk '/default/ { print $3 }'`
echo "pasv_address=${FTP_SERVER_ADDRESS}" >> /etc/vsftpd.conf
/etc/init.d/vsftpd start

cat << EOF
        *************************************************
             
              https://github.com/mkowsiak/FTPDocker     
 
        *************************************************

        NetCAT FTP testing server
        -------------------------
        - FTP User: html
        - FTP Password: html
EOF
/bin/bash
