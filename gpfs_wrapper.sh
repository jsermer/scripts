#!/bin/bash
#GPFS Wrapper Script
(echo 'HOSTNAME,NetworkGPFSFilesystems'
for i in $(/usr/lpp/mmfs/bin/mmlscluster |awk '/'$1'/ {print $2}'|egrep "tudev|mstapp"|sort)
do
	ssh -q $i bash < ($2 $1)
done)
