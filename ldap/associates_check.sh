#!/bin/bash
for i in $(ldapsearch -x -s one -b o=associates -h 10.1.4.115 objectClass=posixGroup cn|awk '/^cn:/ {print $2}')
do
	/home/jsermer/ldap/equivalentToMe_add_dynamic.sh $i
	/home/jsermer/ldap/memberUid_add_dynamic.sh $i
	/home/jsermer/ldap/memberUid_del_dynamic.sh $i
done |tee associates.ldif
