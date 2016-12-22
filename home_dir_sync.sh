#!/bin/bash
http_proxy='' wget http://tunim01.tuc.com/opensystems/etc/hostlist -O /tmp/hostlist
mkdir /tmp/home_dir_sync
rsync -e "ssh -q -o StrictHostKeyChecking=no" -a tunim01:/opt/install/security/home/$(whoami)/. /tmp/home_dir_sync/.
for i in $(egrep '^[^#]' /tmp/hostlist |awk -F, '!/HOSTNAME/ {print $1}'|sort)
do
    echo $i
    rsync -e "ssh -q -o StrictHostKeyChecking=no" -a /tmp/home_dir_sync/. $i:~/.
done
rm -rf /tmp/home_dir_sync
