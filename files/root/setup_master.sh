#!/bin/bash

SOCK=/var/run/mysqld/mysqld.sock

mysql -S $SOCK mysql -e "DROP USER '';"
mysql -S $SOCK mysql -e "DROP USER ''@'localhost';"
mysql -S $SOCK mysql -e 'delete from user where Host like "v%";flush privileges;'

echo "#### priv. settings for root, repl, test"
mysql -S $SOCK -e "grant replication slave, replication client on *.* to 'rep'@'%' identified by 'rep';"
mysql -S $SOCK -e "grant replication client on *.* to 'rep'@'localhost' identified by 'rep';"

# Check priv.
mysql -S $SOCK mysql -e "select Host, User, Password from user where Host = '%' ;"

echo "#### Set master writable."
mysql -S $SOCK -e "set @@global.read_only=0;"
mysql -S $SOCK -e "select @@global.read_only;"

