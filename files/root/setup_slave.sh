#!/bin/bash

MASTER=$1

if [ "$MASTER" == "" ] ; then
	echo Usage: $0 master
	exit 1
fi

SOCK=/var/run/mysqld/mysqld.sock

mysql -S $SOCK -e "stop slave;"
mysql -S $SOCK -e "change master to master_host='$MASTER',master_port=3306, \
master_user='rep', master_password='rep', master_auto_position=1 , MASTER_CONNECT_RETRY=10;"

mysql -S $SOCK -e "start slave;"


mysql -S $SOCK mysql -e "select * from slave_master_info \G;"|egrep -i "log|host|name|uuid|port"


