#!/bin/bash

CANARY=/var/lib/mysql/iml-setup-complete

# Since SQL is dumb I'm doing this.
if [[ -f "$CANARY" ]]; then
    echo "Skipping initial setup."
else
    # Set grants and load the leaked dump into the database.
    echo "!!! Executing initial setup. Configuring user permissions and hydrating the iron_march database."
    echo "!!! Please wait for the SQL import to finish."
    echo "GRANT ALL PRIVILEGES ON iron_march.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES; USE iron_march; SOURCE /media/sql/database.sql;" | mysql -u root --password=$MYSQL_ROOT_PASSWORD
    touch $CANARY
fi
