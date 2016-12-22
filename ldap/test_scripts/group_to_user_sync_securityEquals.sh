#!/bin/bash
ldapsearch -LLL -x -b o=associates -h 10.1.4.115 cn=$1 member| egrep -v 'Inactive|TUSSI' | awk -F\= '/^member:/ {print $2}'|sed 's/,o$//' | {
	found=0
	while read i
	do
		if ! (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 cn=$i securityEquals | grep -i "^securityEquals:[[:space:]]cn=$1,o=Associates" >/dev/null); then
			if [ ${found} -eq 0 ]; then
				echo -e "dn: cn=$i,o=Associates\nchangetype: modify\nadd: securityEquals"
				echo -e "securityEquals: cn=$1,o=Associates"
				found=1
			fi
			if [ ${found} -eq 1 ]; then
				echo
				found=0
			fi
		fi
	done
}
