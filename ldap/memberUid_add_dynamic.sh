#!/bin/bash
found=0
for i in $(ldapsearch -x -b o=associates -h 10.1.4.115 cn=$1 member| grep ^member:|awk '{print $2}'|sed 's/^cn=//;s/,o=Associates.*//'|grep -v Inactive)
do
	if ! (ldapsearch -x -b o=associates -h 10.1.4.115 cn=$1 memberUid | grep -i "^memberUid:.*$i" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: memberUid"
		fi
		found=1
		echo -e "memberUid: $(echo $i | tr 'A-Z' 'a-z')"
	fi
done

if [ $found -eq 1 ]; then
	echo
fi
