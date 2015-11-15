#!/bin/bash

TIMEOUT=2

SOCK=/var/run/mysqld/mysql.sock
mysql -S $SOCK --connect-timeout=$TIMEOUT -e "set @@global.read_only=1;"

