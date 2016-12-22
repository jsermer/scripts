#!/bin/bash
ldapsearch -LLL -x -b o=associates -h $2 cn=$1 securityEquals| egrep -v 'Inactive|TUSSI|,cn|SERVICES' | awk -F\= '/^securityEquals:/ {print $2}'|sed 's/,o$//' | {
	found=0
	while read i
	do
		if ! (ldapsearch -LLL -x -b o=associates -h $2 cn=$i member | grep -i "^member:[[:space:]]cn=${1},o=Associates$" >/dev/null); then
			if [ ${found} -eq 0 ]; then
				echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: securityEquals"
			fi
			found=1
			echo -e "securityEquals: ${i}"
		fi
	done

	if [ ${found} -eq 1 ]; then
		echo
	fi
}
