#!/bin/bash
(ldapsearch -LLL -x -s one -b o=associates -h $1 objectClass=inetOrgPerson cn|awk '/^cn:/ {print $2}') | while read i
do
	/home/jsermer/ldap/user_groupmembership_del.sh ${i} $1
	/home/jsermer/ldap/user_securityEquals_del.sh ${i} $1
done > /home/jsermer/ldap/associates_user_check_ldif_$1.txt
