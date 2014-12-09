#!/bin/sh

#ENTRYPOINT param parsing for RedCap Container

#Args CMD [run.sh]
CMD=$1

#Read env vars parsed $REDCAP_CONFIG
#TODO
sed -e s/your_mysql_host_name/\'$REDCAP_HOST_NAME\'/
sed -e s/your_mysql_db_name/\'$REDCAP_MYSQL_DB_NAME\'/
sed -e s/your_mysql_db_username/\'$REDCAP_MYSQL_USERNAME\'/
sed -e s/your_mysql_db_password/\'$REDCAP_MYSQL_PASSWORD\'/
sed -e s/^\$salt\s*\=''/^\$salt\s*\=\'$REDCAP_MYSQL_SALT\'/

#run the Command now
exec $CMD


