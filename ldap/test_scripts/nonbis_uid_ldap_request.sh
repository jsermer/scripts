#!/bin/bash
ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 "(&(objectClass=posixAccount)(uidNumber=$1))" uid userPassword uidNumber gidNumber cn homeDirectory loginShell gecos description objectClass
