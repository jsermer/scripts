#!/bin/bash
(ldapsearch -LLL -x -s one -b o=associates -h $1 objectClass=posixGroup cn|awk '/^cn:/ {print $2}') | while read i
do
	/home/jsermer/ldap/equivalentToMe_member_add_dynamic.sh ${i} $1
	/home/jsermer/ldap/equivalentToMe_memberUid_add_dynamic.sh ${i} $1
	/home/jsermer/ldap/equivalentToMe_memberUid_del_dynamic.sh ${i} $1
done > /home/jsermer/ldap/equivalentToMe_associates_ldif_$1.txt
