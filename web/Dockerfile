#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [afolarin/redcap:mysql] 
# 2) [afolarin/redcap:webapp]
# 3) [afolarin/redcap:cron]

# USAGE (from redcap-docker/web):
# docker run --name="redcap-web" -v $(pwd)cron-conf/crontab:/app/cron-conf/crontab 
# --link="redcap-db:REDCAP_DB"  --env-file="env.list" -d -p 80:80 afolarin/redcap:webapp


#------------------------------------------------------------------------------
# Redcap Container
# build from inside the ./build dir see README.md
#------------------------------------------------------------------------------

FROM afolarin/cron-apache-php

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# install mysql client
RUN apt-get update && \
        apt-get -yq install mysql-server-5.5 && \
        rm -rf /var/lib/apt/lists/*


# redcap web-application
COPY ./download/redcap /app/redcap

# Startup scripts in /etc/my_init.d are run at container start
RUN mkdir -p /etc/my_init.d
ADD cron-conf.sh /etc/my_init.d/cron-conf.sh
ADD parse_redcap_config.sh /etc/my_init.d/parse_redcap_config.sh
RUN chmod 755 /etc/my_init.d/*.sh

# Daemonised processes
# the single /etc/services/apache/run  (set in afolarin/cron-apache-php)


# the cron running container will require some volumes exposed
# "* * * * * /usr/bin/php /app/redcap/cron.php  > /dev/null" | /usr/bin/crontab -u root -']
#VOLUME ["/usr/bin/", "/app/redcap/"]

