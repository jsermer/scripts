#!/bin/bash
ldapsearch -LLL -x -b o=associates -h $2 cn=$1 member| egrep -v 'Inactive|TUSSI' | awk -F\= '/^member:/ {print $2}'|sed 's/,o$//' | {
	found=0
	while read i
	do
		if ! (ldapsearch -LLL -x -b o=associates -h $2 cn=$1 equivalentToMe | grep -i "^equivalentToMe:[[:space:]]cn=${i},o=Associates" >/dev/null); then
			if [ ${found} -eq 0 ]; then
				echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: equivalentToMe"
			fi
			found=1
			echo -e "equivalentToMe: cn=${i},o=Associates"
		fi
	done

	if [ ${found} -eq 1 ]; then
		echo
	fi
}
