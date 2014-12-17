#------------------------------------------------------------------------------
# Dockerized Redcap for deploying in a variety of environments
#------------------------------------------------------------------------------

#The Containers in the System:
# 1) [afolarin/redcap:mysql] 
# 2) [afolarin/redcap:webapp]
# 3) [afolarin/redcap:cron]

# USAGE (from redcap-docker/web):
# docker run --name="redcap-web" --link="redcap-db:REDCAP_DB" -d -p 80:80 \
#    REDCAP_DB_PORT_3306_TCP_ADDR_="", REDCAP_DB_NAME_="", REDCAP_DB_USER_="admin", \
#    REDCAP_DB_USER_PWD_="hFH1ufw7TLrU", REDCAP_DB_SALT_="TiProTg1983", \
#    afolarin/redcap:webapp



#------------------------------------------------------------------------------
# Redcap Container
# build from inside the ./build dir see README.md
#------------------------------------------------------------------------------

FROM tutum/apache-php

MAINTAINER Amos Folarin <amosfolarin@gmail.com>

# redcap web-application
COPY ./download/redcap /app/redcap


# Runtime sensitive information provided as [--env, --env-file] environment variables,
# which are processed by parse_redcap_config.sh into the database.php file
# control is then passed to the run.sh script
COPY parse_redcap_config.sh /app/
ENTRYPOINT ["/app/parse_redcap_config.sh"]
CMD ["/run.sh"]

