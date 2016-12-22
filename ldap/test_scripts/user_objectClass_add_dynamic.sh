#!/bin/bash
found=0
if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=posixAccount)(!(objectClass=account)))" cn|grep ^cn >/dev/null); then
	if [ $found -eq 0 ]; then
		echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: objectClass"
	fi
	found=1
	echo -e "objectClass: account"
fi

if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=posixAccount)(!(objectClass=shadowAccount)))" cn|grep ^cn >/dev/null); then
	if [ $found -eq 0 ]; then
		echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: objectClass"
	fi
	found=1
	echo -e "objectClass: shadowAccount"
fi

if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=account)(!(objectClass=posixAccount)))" cn|grep ^cn >/dev/null); then
	if [ $found -eq 0 ]; then
		echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: objectClass"
	fi
	found=1
	echo -e "objectClass: posixAccount"
fi

if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=account)(!(objectClass=shadowAccount)))" cn|grep ^cn >/dev/null); then
	if [ $found -eq 0 ]; then
		echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: objectClass"
	fi
	found=1
	echo -e "objectClass: shadowAccount"
fi

if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=shadowAccount)(!(objectClass=account)))" cn|grep ^cn >/dev/null); then
	if [ $found -eq 0 ]; then
		echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: objectClass"
	fi
	found=1
	echo -e "objectClass: account"
fi

if (ldapsearch -LLL -x -b o=associates -h 10.1.4.115 "(&(cn=$1)(objectClass=shadowAccount)(!(objectClass=posixAccount)))" cn|grep ^cn >/dev/null); then
	if [ $found -eq 0 ]; then
		echo -e "dn: cn=$1,o=Associates\nchangetype: modify\nadd: objectClass"
	fi
	found=1
	echo -e "objectClass: posixAccount"
fi

if [ $found -eq 1 ]; then
	echo
fi
