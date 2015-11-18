#!/bin/bash 

HOSTS="v001 v002"

for hst in $HOSTS; do

echo

uuid=$(mysql -u rep -prep  -h $hst -e 'select @@server_uuid;' 2>/dev/null |sed -e "/@@server_uuid/d" )
readonly=$(mysql -u rep -prep  -h $hst -e "select @@global.read_only;" 2>/dev/null |sed -e "/@@global.read_only/d")

echo -e $hst ":\tUUID=" $uuid ", read_only=" $readonly
echo

mysql -u rep -prep  -h $hst -e 'show slave status\G;' 2>/dev/null \
|sed -e 'te' -e 'H;$!d;:e' -e 'x;/^$/d;s/,\n/,/g'|egrep -i 'gtid|Running|Behin'

echo

ssh $hst /sbin/ip add |egrep "172.16.1.251"

echo

done

