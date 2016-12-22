#!/bin/sh
#sudo truecrypt -M uid=jsermer,gid=users /data/documents/truecrypt /home/jsermer/truecrypt
#truecrypt -t /data/documents/truecrypt /home/jsermer/truecrypt
truecrypt -t /data/documents/truecrypt_6.0a /home/jsermer/truecrypt
#gorilla
echo "USE THE FOLLOWING TO LIST:"
echo "pwsafe -f /home/jsermer/truecrypt/passwords.dat --list Personal.http://workcenter.probusiness.com -u -p -E"
echo "USE THE FOLLOWING TO EDIT:"
echo "pwsafe -f /home/jsermer/truecrypt/passwords.dat --edit Personal.http://workcenter.probusiness.com"
#sudo truecrypt -d /home/jsermer/truecrypt
echo "Also don't forget to unmount the truecrypt volume when done with:\n"
echo "truecrypt -d /home/jsermer/truecrypt"
