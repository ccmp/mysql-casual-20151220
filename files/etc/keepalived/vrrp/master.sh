#!/bin/bash

SOCK=/var/run/mysqld/mysqld.sock
mysql -S $SOCK -e "set @@global.read_only=0;"


