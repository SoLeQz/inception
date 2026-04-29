#!/bin/bash
set -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    mysqld --user=mysql --bootstrap << EOF

FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS \'${DB_NAME}\';
CREATER USRR IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \'${DB_NAME}\'.* TO '${DB_USER}'@'%';
ALTER USER'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF
fi

exec mysqld --user=mysql