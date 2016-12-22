#!/bin/bash
found=0
if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=posixGroup))" cn|grep ^cn: >/dev/null); then
	if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=account))" objectClass|grep "^objectClass: account$" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: objectClass"
		fi
		found=1
		echo -e "objectClass: account"
	fi

	if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=posixAccount))" objectClass|grep "^objectClass: posixAccount$" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: objectClass"
		fi
		found=1
		echo -e "objectClass: posixAccount"
	fi

	if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=shadowAccount))" objectClass|grep "^objectClass: shadowAccount$" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: objectClass"
		fi
		found=1
		echo -e "objectClass: shadowAccount"
	fi
fi

if [ $found -eq 1 ]; then
	echo
fi
