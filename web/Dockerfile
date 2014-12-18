#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [afolarin/redcap:mysql] 
# 2) [afolarin/redcap:webapp]
# 3) [afolarin/redcap:cron]

# USAGE (from redcap-docker/web):
# docker run --name="redcap-web" --link="redcap-db:REDCAP_DB" \
#    --env-file="env.list" -d -p 80:80 afolarin/redcap:webapp


#------------------------------------------------------------------------------
# Redcap Container
# build from inside the ./build dir see README.md
#------------------------------------------------------------------------------

FROM tutum/apache-php

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# install mysql client
RUN apt-get update && \
        apt-get -yq install mysql-server-5.5 && \
        rm -rf /var/lib/apt/lists/*


# redcap web-application
COPY ./download/redcap /app/redcap


# Runtime sensitive information provided as [--env, --env-file] environment variables,
# which are processed by parse_redcap_config.sh into the database.php file
# control is then passed to the run.sh script
COPY parse_redcap_config.sh /app/
ENTRYPOINT ["/app/parse_redcap_config.sh"]
CMD ["/run.sh"]

