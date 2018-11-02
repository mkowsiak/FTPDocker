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

# i need this one to make this error
# Can't load /root/.rnd into RNG
# ... Cannot open file:../crypto/rand/randfile.c:88:Filename=/root/.rnd
RUN touch /root/.rnd

# key and cert generation
RUN openssl req -x509 \
  -nodes \
  -newkey rsa:2048 \
  -subj "/C=PL/O=organization/OU=organizational unit/CN=common name" \
  -keyout /etc/ssl/certs/ssl.key \
  -out /etc/ssl/certs/ssl.crt -days 365

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

# make sure to provide vsftpd config
# files
COPY vsftpd.conf.explicitssl /etc/vsftpd.conf.explicitssl
COPY vsftpd.conf.implicitssl /etc/vsftpd.conf.implicitssl
COPY vsftpd.conf.nossl /etc/vsftpd.conf.nossl

# i am not interested in default one
# i will create symlink anyway
RUN rm /etc/vsftpd.conf

# init.d script with sleep command
# that prevents failover during
# /etc/init.d/vsftpd start
# it took me quite some time to understand where
# error message comes from
COPY vsftpd /etc/init.d/
RUN chmod +x /etc/init.d/vsftpd

# set server name to prevent nasty message
# from /etc/init.d/apache2 start
RUN echo "ServerName pi" >> /etc/apache2/apache2.conf

# expose ports
EXPOSE 80
EXPOSE 20
EXPOSE 21
EXPOSE 990

# for passive ftp
EXPOSE 21100-21110

# entry point for newly instanced container
CMD /bin/start.sh
