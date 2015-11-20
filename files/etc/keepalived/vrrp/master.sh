#!/bin/bash

SOCK=/var/run/mysqld/mysqld.sock

while true ; do
mysql -S $SOCK -e "show slave status\G;"|egrep "Seconds_Behind_Master: 0|Seconds_Behind_Master: NULL"
if [ "$?" = "0" ] ; then 
	break
else
	echo Waiting until sql thread finish.
fi
sleep 1
done

mysql -S $SOCK -e "set @@global.read_only=0;"


