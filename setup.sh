#!/bin/bash

START=$(date)

apt-get install python git gcc python-setuptools python-dev mysql-client -y
easy_install pip 
pip install ansible 

cat /dev/null >  ~/.ssh/known_hosts
ssh-keyscan  github.com >> ~/.ssh/known_hosts

cd ~/
if [ ! -d mysql-casual-20151220 ]; then
	git clone git@github.com:ktaka-ccmp/mysql-casual-20151220.git
fi

cd mysql-casual-20151220 
git checkout mysql56
#git checkout mysql57
#git checkout master
git pull

for hst in v001 v002 ; do
	ssh-keyscan  $hst >> ~/.ssh/known_hosts
	ssh $hst apt-get install -y python > /dev/null &
done
wait

echo "Run Playbook"
time ansible-playbook -i hosts main.yml -vv

echo Run the following 
echo "ssh v001 '/root/setup_master.sh; /root/setup_slave.sh v002'"
echo "ssh v002 '/root/setup_slave.sh v001'"

echo START=$START
echo END=$(date)


