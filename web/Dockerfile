#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
# Based on the phusion + tutum-php container afolarin/cron-apache-php
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [afolarin/redcap:mysql] 
# 2) [afolarin/redcap:webapp]

# BUILD:
# $ cd web/
# $ docker build --tag="afolarin/redcap:webapp" .

# USAGE:
# docker run -d --name="redcap-web" -v $(pwd)/cron-conf/:/cron-conf/ --link="redcap-db:REDCAP_DB"  --env-file="env.list" --publish="80:80" afolarin/redcap:webapp

# Installation Checks: http://<IPADDRESS>/redcap/redcap_v6.0.12/ControlCenter/check.php?upgradeinstall=1

#------------------------------------------------------------------------------
# Redcap Container
# build from inside the ./build dir see README.md
#------------------------------------------------------------------------------

FROM afolarin/cron-apache-php

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# install mysql client
RUN apt-get update && \
	    apt-get -yq install \
	    mysql-server-5.5 \
	    php5-mcrypt

#setup mycrypt and restart apache
RUN php5enmod mcrypt && \
	service apache2 restart


# copy redcap application into the container /app which is linked as /var/www/html
# and create default index.php at web root
COPY ./download/redcap /app/redcap
COPY ./index.php /app/index.php


###############################################################################
# my_runit: Startup scripts in /etc/my_init.d are run at container start
###############################################################################
RUN mkdir -p /etc/my_init.d
ADD a_logfile.sh /etc/my_init.d/a_logfile.sh
ADD cron-conf.sh /etc/my_init.d/cron-conf.sh
ADD parse_redcap_config.sh /etc/my_init.d/parse_redcap_config.sh
RUN chmod 755 /etc/my_init.d/*.sh


###############################################################################
# my_runit: Daemonised processes /etc/service/<name>/run
###############################################################################
#



# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


