#!/bin/bash

SOCK=/var/run/mysqld/mysql.sock
mysql -S $SOCK -e "set @@global.read_only=0;"


