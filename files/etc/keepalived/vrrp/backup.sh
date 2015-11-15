#!/bin/bash

TIMEOUT=2

SOCK=/var/run/mysqld/mysqld.sock
mysql -S $SOCK --connect-timeout=$TIMEOUT -e "set @@global.read_only=1;"

