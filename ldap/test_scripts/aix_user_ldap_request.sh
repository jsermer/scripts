#!/bin/bash
ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 "(&(objectClass=posixAccount)(uid=$1))" uid uidNumber gidNumber homeDirectory loginShell gecos userpassword shadowlastchange shadowmax shadowmin shadowexpire shadowwarning
