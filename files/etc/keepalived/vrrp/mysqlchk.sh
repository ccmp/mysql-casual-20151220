#!/bin/bash

TIMEOUT=60

SOCK=/var/run/mysqld/mysqld.sock

mysql -S $SOCK --connect-timeout=$TIMEOUT -e "show variables like 'server_id';"

