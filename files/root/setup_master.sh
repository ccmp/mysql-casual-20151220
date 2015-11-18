#!/bin/bash

SOCK=/var/run/mysqld/mysqld.sock

echo "#### priv. settings for root, repl, test"
mysql -S $SOCK -e "grant replication slave, replication client on *.* to 'rep'@'%' identified by 'rep';"
mysql -S $SOCK -e "grant replication client on *.* to 'rep'@'localhost' identified by 'rep';"
mysql -S $SOCK -e "grant all privileges on *.*  to 'root'@'%' identified by 'root' with grant option;"

# Check priv.
mysql -S $SOCK mysql -e "select Host, User from user where Host = '%' ;"

echo "#### Set master writable."
mysql -S $SOCK -e "set @@global.read_only=0;"
mysql -S $SOCK -e "select @@global.read_only;"

