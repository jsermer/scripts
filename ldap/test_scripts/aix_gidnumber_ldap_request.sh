#!/bin/bash
ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 "(&(objectClass=posixAccount)(gidnumber=$1))" uid
