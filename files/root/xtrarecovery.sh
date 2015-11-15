#!/bin/bash


usage(){
echo "Usage: $0 BACKUP_FILE MASTER"
exit 1
}

BKFILE=$1
MASTER=$2

TMPDIR=./xtrabackup_tmp
MYCNF=/etc/mysqld/my.cnf 
DBDIR=/var/lib/mysqld
DBDIR=/var/run/mysqld/mysqld.sock

if [ "$MASTER" = "" ] ; then usage ; fi
[ ! -f $BKFILE ] && echo $BKFILE not found && usage
[ ! -f $MYCNF ] && echo $MYCNF not found && usage
[ ! -d $DBDIR ] && echo $DBDIR not found && usage

service mysql stop
mv $DBDIR ${DBDIR}.$(date +"%Y%m%d%H%M" )
mkdir -p $DBDIR

[ -d $TMPDIR ] && rm -rf $TMPDIR 
mkdir -p $TMPDIR

tar -C $TMPDIR -ixvf $BKFILE 
innobackupex --use-memory=1G --apply-log $TMPDIR
innobackupex  --copy-back  --defaults-file=$MYCNF $TMPDIR
chown -R mysql.mysql $DBDIR

cp -p ${MYCNF}{,.bk}
echo skip-slave-start >> $MYCNF
service mysql start

mysql -S $SOCK -e "$(egrep -v MASTER_AUTO_POSITION  $DBDIR/xtrabackup_slave_info)"
mysql -S $SOCK -e " change master to master_host='$MASTER',master_port=3306, master_user='rep', master_password='rep', master_auto_position=1 , MASTER_CONNECT_RETRY=10;"
mysql -S -e "start slave;"

sed -i "s/skip-slave-start//g" $MYCNF
rm -rf $TMPDIR

sleep 3
mysql -S $SOCK -e "show slave status\G;"|sed '/.*: $/d'


