#!/bin/bash
#Network attached GPFS filesystem check
( echo $HOSTNAME; /usr/lpp/mmfs/bin/mmfsadm dump nsd|grep $1|awk '!/\/dev\/sd/ {print $1}'|tr '\n' ';'|xargs -i /usr/lpp/mmfs/bin/mmlsnsd -d "{}"|awk '/gpfs.*nsd/ {print $1}'|sort -u) |tr '\n' ','; echo
