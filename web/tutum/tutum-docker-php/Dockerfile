#FROM ubuntu:trusty

#need local cron for redcap so rebasing on phusions fat container image
FROM phusion/baseimage:0.9.0
MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
#??# RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]


####-------------------- start tutum/apache-php layers -----------------------#

# Install base packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && \
    apt-get -yq install \
        curl \
        apache2 \
        libapache2-mod-php5 \
        php5-mysql \
        php5-gd \
        php5-curl \
        php-pear \
        php-apc && \
    rm -rf /var/lib/apt/lists/*
RUN sed -i "s/variables_order.*/variables_order = \"EGPCS\"/g" /etc/php5/apache2/php.ini
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Add image configuration and scripts
#ADD run.sh /run.sh
#RUN chmod 755 /*.sh

# Startup scripts in /etc/my_init.d are run at container start
#RUN mkdir -p /etc/my_init.d
#ADD cron-conf.sh /etc/my_init.d/cron-conf.sh
#ADD parse_redcap_config.sh /etc/my_init.d/parse_redcap_config.sh
#RUN chmod 775 /etc/my_init.d/*.sh

# Daemonised processes
# Runtime sensitive information provided as [--env, --env-file] environment variables,
# which are processed by parse_redcap_config.sh into the database.php file
# control is then passed to the run.sh script
COPY run.sh /app/
COPY run /etc/service/apache/
RUN chmod 775 /etc/service/apache/run





# Configure /app folder with sample app
RUN mkdir -p /app && rm -fr /var/www/html && ln -s /app /var/www/html
ADD sample/ /app

EXPOSE 80
WORKDIR /app



# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*





