#!/bin/bash
ldapsearch -LLL -x -b o=associates -h $2 cn=$1 memberUid| egrep -v 'Inactive|TUSSI' | awk '/^memberUid:/ {print $2}' | {
	found=0
	while read i
	do
		if ! (ldapsearch -LLL -x -b o=associates -h $2 cn=$1 equivalentToMe | grep -i "^equivalentToMe:[[:space:]]cn=${i},o=Associates$" >/dev/null); then
			if [ ${found} -eq 0 ]; then
				echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: memberUid"
			fi
			found=1
			echo -e "memberUid: ${i}"
		fi
	done

	if [ ${found} -eq 1 ]; then
		echo
	fi
}
