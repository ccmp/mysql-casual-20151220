#!/bin/bash

mysql --host 172.16.1.251 -u rep -prep \
-e 'select @@report_host, @@report_port, @@global.read_only;

