#!/bin/bash

#------------------------------------------------------------------------------
# DESC: 
# Setup config (mostly hooking up the database container and processing
# some additional server reqirements of redcap) then execute the CMD transparently:

# AUTHOR: Amos Folarin <amosfolarin@gmail.com>

# USAGE: 
# Initialize and parameterize the 
# [ENTRYPOINT] =  parse_redcap_config.sh [CMD = /run.sh]
# parse_redcap_config.sh "/run.sh"
# 
# This script is not required just to restart the container.
# To restart the container, with default CMD and ENTRYPOINT if you need to 
# restart the apache webserver, using pre-existing params.
#------------------------------------------------------------------------------

#ENTRYPOINT param parsing for RedCap Container

#CMD to be run after config has been done
CMD=${1}

#RUNTIME ENV VARS
REDCAP_DB_PORT_3306_TCP_ADDR_="" #The hostname of the linked database container
REDCAP_DB_NAME_="redcap_mysql" #redcap database name created in mysql container
REDCAP_DB_USER_="redcap_admin" #redcap database user, not the default mysql container "admin" user which is overprivileged for redcap
REDCAP_DB_USER_PWD_="" #redcap database password
REDCAP_DB_SALT_="" #the >12 digit salt for the database

## check if each env var exists or exit
if [[ -n ${REDCAP_DB_PORT_3306_TCP_ADDR} ]]
then 
REDCAP_DB_PORT_3306_TCP_ADDR_=${REDCAP_DB_PORT_3306_TCP_ADDR}
else
echo "error undefined REDCAP_DB_PORT_3306_TCP_ADDR\n" >&2
exit 1
fi

if [[ -n ${REDCAP_DB_NAME} ]]
then
REDCAP_DB_NAME_=${REDCAP_DB_NAME}
else
echo "error undefined REDCAP_DB_NAME\n" >&2
exit 1
fi

if [[ -n ${REDCAP_DB_USER} ]]
then
REDCAP_DB_USER_=${REDCAP_DB_USER}
else
echo "error undefined REDCAP_DB_USER\n" >&2
exit 1
fi

if [[ -n ${REDCAP_DB_USER_PWD} ]]
then
REDCAP_DB_USER_PWD_=${REDCAP_DB_USER_PWD}
else
echo "error undefined REDCAP_DB_USER_PWD\n" >&2
exit 1
fi

if [[ -n ${REDCAP_DB_SALT} ]]
then
REDCAP_DB_SALT_=${REDCAP_DB_SALT}
else
echo "error undefined REDCAP_DB_SALT\n" >&2
exit 1
fi

## CONNECT TO THE MYSQL SERVER CONTAINER as the default tutum MYSQL_USER "admin", which is used to
## create myql redcap database, user and password as provided at runtime
#mysql -h${REDCAP_DB_PORT_3306_TCP_ADDR_} -u${MYSQL_USER} -p${MYSQL_PASS} << EOF
#CREATE DATABASE ${REDCAP_DB_NAME_};
#CREATE USER "${REDCAP_DB_USER_}"@"${REDCAP_DB_PORT_3306_TCP_ADDR_}" IDENTIFIED BY "${REDCAP_DB_USER_PWD_}";
#GRANT DROP,DELETE,INSERT,SELECT,UPDATE ON ${REDCAP_DB_NAME_}.* TO "${REDCAP_DB_USER_}"@"${REDCAP_DB_PORT_3306_TCP_ADDR_}";
#EOF

#User account for connecting from remote host, a root account exists for connecting from localhost
## CONNECT TO THE MYSQL SERVER CONTAINER as the default tutum MYSQL_USER "admin", which is used to
## create myql redcap database, user and password as provided at runtime
mysql -h${REDCAP_DB_PORT_3306_TCP_ADDR_} -u${MYSQL_USER} -p${MYSQL_PASS} << EOF
CREATE DATABASE ${REDCAP_DB_NAME_};
CREATE USER "${REDCAP_DB_USER_}"@"%" IDENTIFIED BY "${REDCAP_DB_USER_PWD_}";
GRANT DROP,DELETE,INSERT,SELECT,UPDATE ON ${REDCAP_DB_NAME_}.* TO "${REDCAP_DB_USER_}"@"%";
FLUSH PRIVILEGES;
EOF

## Substitute env vars parsed at runtime into web-container:/app/redcap/database.php config file
sed -in -e "s/your_mysql_host_name/${REDCAP_DB_PORT_3306_TCP_ADDR_}/" \
-e "s/your_mysql_db_name/${REDCAP_DB_NAME_}/" \
-e "s/your_mysql_db_username/${REDCAP_DB_USER_}/" \
-e "s/your_mysql_db_password/${REDCAP_DB_USER_PWD_}/" \
-e "s/\$salt = ''/\$salt = ${REDCAP_DB_SALT_}/" \
/app/redcap/database.php

#Unset the password env var
export REDCAP_DB_USER_PWD=""


# OTHER REDCAP CONFIG REQUIREMENTS
# postinstall checklist: http://localhost/redcap/redcap_v6.0.12/ControlCenter/check.php?upgradeinstall=1

## increase upload_max_filesize in php.ini
sed -in -e "s/upload_max_filesize = 2M/upload_max_filesize = 32M/" /etc/php5/apache2/php.ini
sed -in -e "s/post_max_size = 8M/post_max_size = 32M/" /etc/php5/apache2/php.ini

## uncomment max_input_vars in php.ini
sed -in -e "s/\; max_input_vars = 1000/max_input_vars = 10000/" /etc/php5/apache2/php.ini


## setup cron, may require some supervisor? - CRITICAL
## --> could only setup *cron* as a multiprocess container, have based on phusion/baseimage

## setup SMTP server for emails - CRITICAL
# NOTE DONE AS DEFAULT -- REQUIRE FOR PRODUCTION

## https + SSL certs strongly - CRITICAL
# NOT DONE AS DEFAULT -- REQ FOR PRODUCTION

## Mcrypt extenstion not installed - RECOMMENDED
# DONE -- installed php5-mycrypt

## Missing UTF-8 fonts for PDF export - RECOMMENDED
# DONE -- add redcap/webtools2/pdf

## Change default location for edocs folder (i.e. not in /apt web accessible)- RECOMMENDED
cp -r /app/redcap/edocs /
chown www-data:www-data /edocs -R

## RESTART apache so uses new config
#/etc/init.d/apache2 restart


# NOTE! moving control of run.sh CMD to phusion/baseimage runit (/etc/services/apache/run) 
# and above parsed configuration to the phusion/baseimage startup scripts (/etc/my_init.d)
# --- commenting out below as this script only handles initialization ---
#LASTLY: execute the docker run CMD now, standup apache.
#$CMD



#env
#/bin/bash
