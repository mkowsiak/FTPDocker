#!/bin/bash


FTP_SERVER_ADDRESS=`/sbin/ip route|awk '/default/ { print $3 }'`

if [ "$1" != "explicit_ssl" ] && [ "$1" != "implicit_ssl" ] && [ "$1" != "no_ssl" ]
then
  cat << EOFA
            *************************************************
             
                  https://github.com/mkowsiak/FTPDocker     
 
            *************************************************

            NetCAT FTP testing server
            -------------------------
            Something went wrong. Make sure to run it using one of
            the options:

            - no_ssl,
            - implicit_ssl,
            - explicit_ssl.

            Like this:

            docker run -i \\
              -p 80:80 \\
              -p 2020:20 \\
              -p 2021:21 \\
              -p 990:990 \\
              -p 21100-21110:21100-21110
              ftptest \\
              /bin/start.sh no_ssl

EOFA
  exit 1
fi

if [ "$1" == "no_ssl" ] ; then
  ln -sf /etc/vsftpd.conf.nossl /etc/vsftpd.conf
else
  if [ "$1" == "implicit_ssl" ] ; then
    ln -sf /etc/vsftpd.conf.implicitssl /etc/vsftpd.conf
  else
    ln -sf /etc/vsftpd.conf.explicitssl /etc/vsftpd.conf
  fi
fi

echo "pasv_address=${FTP_SERVER_ADDRESS}" >> /etc/vsftpd.conf

/etc/init.d/apache2 start
/etc/init.d/vsftpd start

cat << EOF
        *************************************************
             
              https://github.com/mkowsiak/FTPDocker     
 
        *************************************************

        NetCAT FTP testing server
        -------------------------
        - FTP User: html
        - FTP Password: html
        -------------------------

EOF

# we want to prevent container from quiting
/bin/bash
