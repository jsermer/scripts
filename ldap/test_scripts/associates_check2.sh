#!/bin/bash
(ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 objectClass=posixGroup cn|awk '/^cn:/ {print $2}') | while read i
do
	/home/jsermer/ldap/group_to_user_sync_securityEquals.sh ${i}
	/home/jsermer/ldap/group_to_user_sync_groupMembership.sh ${i}
	/home/jsermer/ldap/user_to_group_sync.sh ${i}
done > /home/jsermer/ldap/associates_ldif2.txt
