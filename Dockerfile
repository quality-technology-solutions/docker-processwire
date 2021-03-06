FROM ubuntu:17.10
MAINTAINER Sukru Uzel <sukru.uzel@gmail.com>

# Packages installation
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y \
    git \
    curl \
    mysql-client \
    apache2 \
    libapache2-mod-php7.1 \
    php7.1 \
    php7.1-cli \
    php7.1-gd \
    php7.1-opcache \
    php7.1-json \
    php7.1-ldap \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-xml \
    php7.1-xsl \
    php7.1-zip \
    php7.1-soap 

# Update the default apache site with the config we created.
COPY config/apache/default.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Update php.ini
RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.1/apache2/php.ini
RUN sed -ri 's/^display_errors\s*=\s*Off/display_errors = On/g' /etc/php/7.1/cli/php.ini

# Install ProcessWire
RUN git clone https://github.com/processwire/processwire.git -b master /var/www/pw
RUN chown -R www-data:www-data /var/www/pw

# Expose
EXPOSE 80

# Clean
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/www/pw/.git

# Init
ADD scripts/init.sh /init.sh
RUN chmod +x /init.sh
CMD ["/init.sh"]
