#!/bin/bash

DB=/var/lib/mysqld
SOCK=/var/run/mysqld/mysqld.sock

echo Backup Started at $(date)

binlog=$(mysql -S $SOCK -e "flush logs;show master logs;"|tail -n 1 |sed -n 's/\(.*\.[0-9]\{6\}\).*/\1/p')
mysql -S $SOCK -e "purge binary logs to '$binlog';"

innobackupex --defaults-file=/etc/mysql/my.cnf --socket=$SOCK --user=root --slave-info --safe-slave-backup --stream=tar ./ | gzip - > xtrabackup.$(date +"%Y%m%d%H%M" ).tar.gz

echo Backup Completed at $(date)

