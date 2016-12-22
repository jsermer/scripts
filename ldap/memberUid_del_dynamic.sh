#!/bin/bash
found=0
for i in $(ldapsearch -x -b o=associates -h 10.1.4.115 cn=$1 memberUid| grep ^memberUid:|awk '{print $2}'|sed 's/^cn=//;s/,o=Associates.*//')
do
	if ! (ldapsearch -x -b o=associates -h 10.1.4.115 cn=$1 member | grep -i "^member:.*$i" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: memberUid"
		fi
		found=1
		echo -e "memberUid: $i"
	fi
done

if [ $found -eq 1 ]; then
	echo
fi
