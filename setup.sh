#!/bin/bash

START=$(date)

apt-get install python git gcc python-setuptools python-dev -y
easy_install pip 
pip install ansible 

cat /dev/null >  ~/.ssh/known_hosts
ssh-keyscan  github.com >> ~/.ssh/known_hosts

cd ~/
if [ ! -d mysql-casual-20151220 ]; then
	git clone git@github.com:ktaka-ccmp/mysql-casual-20151220.git
fi

cd mysql-casual-20151220 
git checkout master
git pull

for hst in v001 v002 ; do
	ssh-keyscan  $hst >> ~/.ssh/known_hosts
	ssh $hst apt-get install -y python > /dev/null &
done
wait

echo "Run Playbook"
time ansible-playbook -i hosts main.yml -vv

echo START=$START
echo END=$(date)


