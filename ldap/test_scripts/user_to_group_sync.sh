#!/bin/bash
ldapsearch -LLL -x -b o=associates -h 10.1.4.115 securityEquals="cn=$1,o=Associates" dn | egrep -v 'Inactive|TUSSI|^$' | awk -F\= '/^dn:/ {print $2}'|sed 's/,o$//' | {
	found=0
	while read i
	do
		if ! (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 cn=$1 member | grep -i "^member:[[:space:]]cn=${i},o=Associates" >/dev/null); then
			if [ ${found} -eq 0 ]; then
				echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: member"
			fi
			found=1
			echo -e "member: cn=${i},o=Associates"
		fi
	done

	if [ ${found} -eq 1 ]; then
		echo
	fi

}
