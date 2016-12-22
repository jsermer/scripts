#!/bin/bash
for i in $(ldapsearch -x -s one -b o=associates -h 10.1.4.115 cn=$1 groupMembership|awk '/^groupMembership:/ {print $2}'|sed 's/cn=//;s/,o=Associates//')
do
	/home/jsermer/ldap/equivalentToMe_add_dynamic.sh $i
	/home/jsermer/ldap/memberUid_del_dynamic.sh $i
	/home/jsermer/ldap/memberUid_add_dynamic.sh $i
done |tee $1.ldif
