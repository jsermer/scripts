#!/bin/bash
(ldapsearch -LLL -x -s one -b o=associates -h $1 objectClass=posixGroup cn|awk '/^cn:/ {print $2}') | while read i
do
	/home/jsermer/ldap/group_equivalentToMe_add.sh ${i} $1
	/home/jsermer/ldap/group_memberUid_add.sh ${i} $1
	/home/jsermer/ldap/group_memberUid_del.sh ${i} $1
done > /home/jsermer/ldap/associates_group_check_ldif_$1.txt
