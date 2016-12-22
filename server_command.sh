#!/bin/bash
http_proxy='' wget http://tunim01.tuc.com/opensystems/etc/hostlist -O /tmp/hostlist
for i in $(egrep '^[^#]' /tmp/hostlist |awk -F, '!/HOSTNAME/ {print $1}'|egrep -iv '3par|tuintl|inthpux'|sort)
do
    echo $i
    ssh -o StrictHostKeyChecking=no -q $i $1 || echo "*****COULDNT LOG IN*****"
done
