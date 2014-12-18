# CONNECT TO THE MYSQL SERVER CONTAINER as the default tutum MYSQL_USER "admin", which is used to
# create myql redcap database, user and password as provided at runtime

mysql -h${REDCAP_DB_PORT_3306_TCP_ADDR_} -u${MYSQL_USER} -p${MYSQL_PASS}

CREATE DATABASE ${REDCAP_DB_NAME_};
CREATE USER "${REDCAP_DB_USER_}"@"localhost" IDENTIFIED BY "${REDCAP_DB_USER_PWD_}";
GRANT DROP,DELETE,INSERT,SELECT,UPDATE ON * . * TO "${REDCAP_DB_USER_}"@"localhost";

