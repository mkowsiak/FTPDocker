FROM ubuntu:18.10

LABEL author="michal@owsiak.org"
LABEL description="FTP connection test server for NetCAT"

# some interactive settings
RUN export DEBIAN_FRONTEND=noninteractive

# first of all, make sure to configure tzdata
# it is required by apache stuff anyway
RUN apt-get update
RUN apt-get install -y tzdata

# I want to avoid time zone questions in console
# while configuring tzdata
RUN ln -fs /usr/share/zoneinfo/Europe/Warsaw /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

# we need some packages to be installed
RUN apt-get install -y apache2
RUN apt-get install -y vsftpd
RUN apt-get install -y vim
RUN apt-get install -y libapache2-mod-php
RUN apt-get install -y iproute2
RUN apt-get install -y ftp

# stolen from here: https://gist.github.com/thbkrkr/aa16435cb6c183e55a33
RUN openssl rand -base64 48 > passphrase.txt
RUN openssl genrsa -aes128 -passout file:passphrase.txt -out server.key 2048
RUN openssl req -new \
    -passin file:passphrase.txt \
    -key server.key \
    -out server.csr \
    -subj "/C=PL/O=organization/OU=organizational unit/CN=common name"
RUN cp server.key server.key.org
RUN openssl rsa \
    -in server.key.org \
    -passin file:passphrase.txt \
    -out server.key
RUN openssl x509 \
    -req -days 36500 \
    -in server.csr \
    -signkey server.key \
    -out server.crt

# i will put them in a safe place, where vsftpd will
# access these
RUN mv server.crt /etc/ssl/certs/ssl.crt
RUN mv server.key /etc/ssl/certs/ssl.key

# create user that will have access to
# /var/www/html (it can be done better with 
# virtual users - for me, it's enough)
RUN rm -rf /var/www/html
RUN adduser \
    --disabled-password \
    --home /var/www/html \
    --gecos "" \
    html

# i want a very simple password
RUN echo "html:html" | chpasswd html

# create /var/www/html
ADD index.php /var/www/html

# create startup script
ADD start.sh /bin/
RUN chmod +x /bin/start.sh

# make sure to setup vsftpd
COPY vsftpd.conf /etc/vsftpd.conf

# init.d script with sleep command
# that prevents failover during
# /etc/init.d/vsftpd start
COPY vsftpd /etc/init.d/
RUN chmod +x /etc/init.d/vsftpd

# set server name to prevent nasty message
# from /etc/init.d/apache2 start
RUN echo "ServerName pi" >> /etc/apache2/apache2.conf

# expose ports
EXPOSE 80
EXPOSE 20
EXPOSE 21

# for passive ftp
EXPOSE 10090-10100

# entry point for newly instanced container
CMD /bin/start.sh
