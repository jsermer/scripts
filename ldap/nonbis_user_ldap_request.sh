#!/bin/bash
ldapsearch -x -s one -b o=associates -h 10.1.4.115 "(&(objectClass=posixAccount)(uid=$1))" uid userPassword uidNumber gidNumber homeDirectory loginShell gecos description objectClass
