#!/bin/bash
found=0
if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=posixAccount))" uid|grep ^uid: >/dev/null); then
	if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=groupOfNames))" objectClass|grep "^objectClass: groupOfNames$" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: objectClass"
		fi
		found=1
		echo -e "objectClass: groupOfNames"
	fi

	if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=posixGroup))" objectClass|grep "^objectClass: posixGroup$" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: objectClass"
		fi
		found=1
		echo -e "objectClass: posixGroup"
	fi

	if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=uamPosixGroup))" objectClass|grep "^objectClass: uamPosixGroup$" >/dev/null); then
		if [ $found -eq 0 ]; then
			echo -e "dn: cn=$1,o=Associates\nchangetype: modify\ndelete: objectClass"
		fi
		found=1
		echo -e "objectClass: uamPosixGroup"
	fi
fi

if [ $found -eq 1 ]; then
	echo
fi
