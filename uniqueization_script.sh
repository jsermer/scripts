#!/bin/bash
ln -s /home /u
mount 10.2.15.21:/opt/install/security/sles9 /mnt
cp -Rp /mnt/* /
umount /mnt
mount 10.2.15.21:/opt/install/security/home /mnt
cp -Rp /mnt/* /home/
umount /mnt
chmod 700 /usr/local/bin/groupcache
groupcache
id jsermer
chkstat -set /etc/permissions
echo "export TMOUT=1800" >> /etc/profile
echo "readonly TMOUT" >> /etc/profile
echo "groupmod='groupmod -P /etc/local'" >> /etc/profile
echo "groupadd='groupadd -P /etc/local'" >> /etc/profile
SuSEconfig --module sendmail
rcsendmail stop
rcsendmail start
chkconfig powersaved off
chkconfig isdn off
chkconfig cups off
chkconfig slpd off
chkconfig xntpd on
/etc/init.d/powersaved stop
/etc/init.d/isdn stop
/etc/init.d/cups stop
/etc/init.d/slpd stop
/etc/init.d/xntpd restart
( crontab -l| sed '/DO NOT EDIT/d;/vixie/d;/installed on/d'; echo "20 * * * * /usr/local/bin/groupcache 1>>/var/log/groupcache.log"; ) | crontab -
mv /etc/sysconfig/network/ifcfg-eth* /etc/sysconfig/network/ifcfg-eth0
echo -e "BOOTPROTO='static'\nUNIQUE=''\nSTARTMODE='onboot'\nIPADDR='10.2.251.33'\nNETMASK='255.255.255.0'\nNETWORK='10.2.251.0'\nBROADCAST='10.2.251.255'\nMTU=''\nREMOTE_IPADDR=''\n" > /etc/sysconfig/network/ifcfg-eth0
sed -i "/127.0.0.2.*linux$/d" /etc/hosts
echo -e "10.2.251.33 mspoc04.tuc.com mspoc04\n" >> /etc/hosts
echo -e "default 10.2.251.1 - -\n" > /etc/sysconfig/network/routes
sed -i "s/linux.tuc.com/mspoc04.tuc.com/g" /etc/HOSTNAME /etc/sendmail.cf
date | mail -s"$HOSTNAME" jsermer
date | mail -s"$HOSTNAME" jsermer@tuc.com
date | mail -s"$HOSTNAME" jsermer@transunion.com
