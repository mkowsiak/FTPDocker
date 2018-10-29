#!/bin/bash

/etc/init.d/apache2 start

FTP_SERVER_ADDRESS=`/sbin/ip route|awk '/default/ { print $3 }'`

if [ "$1" != "ssl" ] ; then
  if [ "$1" != "nossl" ] ; then
    cat << EOFA
            *************************************************
             
                  https://github.com/mkowsiak/FTPDocker     
 
            *************************************************

            NetCAT FTP testing server
            -------------------------
            Something went wrong. Make sure to run it using ssl or nossl
            option. Like this:

            docker run -i \\
              -p 80:80 \\
              -p 2020:20 \\
              -p 2021:21 \\
              ftptest \\
              /bin/start.sh ssl

            or

            docker run -i
              -p 80:80 \\
              -p 2020:20 \\
              -p 2021:21 \\
              ftptest \\
              /bin/start.sh nossl
EOFA
    exit 1
  else
    ln -sf /etc/vsftpd.conf.nossl /etc/vsftpd.conf
  fi
else
  ln -sf /etc/vsftpd.conf.ssl /etc/vsftpd.conf
fi

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
