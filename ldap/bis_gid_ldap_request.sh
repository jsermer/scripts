#!/bin/bash
ldapsearch -x -s one -b o=associates -h 10.1.4.115 "(&(objectClass=posixGroup)(gidNumber=$1))" cn userPassword memberUid uniqueMember gidNumber
