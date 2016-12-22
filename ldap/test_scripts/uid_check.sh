#!/bin/bash
(ldapsearch -LLL -x -s one -b o=associates -h $2 cn=$1 groupMembership|awk -F\= '/^groupMembership:/ {print $2}'|sed 's/,o$//') | while read i
do
	/home/jsermer/ldap/equivalentToMe_add_dynamic.sh ${i} $2
	/home/jsermer/ldap/memberUid_del_dynamic.sh ${i} $2
	/home/jsermer/ldap/memberUid_add_dynamic.sh ${i} $2
done |tee $1.ldif
