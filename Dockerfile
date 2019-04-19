FROM debian:stretch-slim

#Install apache & curl
RUN apt-get update \
    && apt-get install -y apache2 curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://deb.nodesource.com/setup_11.x -o nodesource_setup.sh

RUN bash nodesource_setup.sh

#Install nodejs
RUN apt-get update \
    && apt-get install -y nodejs build-essential \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Install yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt update \
    && apt install yarn

#Set up apache variables
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

#Remove default apache site
RUN a2dissite 000-default \
    && a2enmod proxy proxy_http proxy_fcgi rewrite headers deflate expires 

EXPOSE 80

CMD usermod -u 1000 www-data && /usr/sbin/apache2ctl -D FOREGROUND