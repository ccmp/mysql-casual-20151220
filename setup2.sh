#!/bin/bash

START=$(date)

echo "Run Playbook"
time ansible-playbook -i hosts main.yml -vv

echo Run the following 
echo "ssh v151 '/root/setup_master.sh; /root/setup_slave.sh v152'"
echo "ssh v152 '/root/setup_slave.sh v151'"

echo START=$START
echo END=$(date)


