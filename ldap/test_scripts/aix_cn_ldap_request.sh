#!/bin/bash
ldapsearch -LLL -x -s one -b o=associates -h 10.1.4.115 "(&(objectClass=posixGroup)(cn=$1))" cn gidnumber memberuid
