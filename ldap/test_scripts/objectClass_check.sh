#!/bin/bash
(ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 objectClass=posixGroup cn|awk '/^cn:/ {print $2}') | while read i
do
	/home/jsermer/ldap/group_objectClass_del_dynamic.sh ${i}
done |tee /home/jsermer/ldap/objectClass_ldif.txt

(ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 objectClass=posixAccount uid|awk '/^uid:/ {print $2}') | while read i
do
	/home/jsermer/ldap/user_objectClass_del_dynamic.sh ${i}
done |tee -a /home/jsermer/ldap/objectClass_ldif.txt

(ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 cn=* cn|awk '/^cn:/ {print $2}') | while read i
do
	/home/jsermer/ldap/user_objectClass_add_dynamic.sh ${i}
done |tee -a /home/jsermer/ldap/objectClass_ldif.txt
