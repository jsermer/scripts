#! /bin/bash
mkdir /tmp/preupgrade
cat /etc/sysconfig/network/routes >>/tmp/preupgrade/"$HOSTNAME".routesfile
route >> /tmp/preupgrade/"$HOSTNAME".routetable
ifconfig >> /tmp/preupgrade/"$HOSTNAME".ifconfig
cat /etc/fstab >> /tmp/preupgrade/"$HOSTNAME".fstab
mount >> /tmp/preupgrade/"$HOSTNAME".mount
chkconfig --list >> /tmp/preupgrade/"$HOSTNAME".chkconfig
vgdisplay -v >> /tmp/preupgrade/"$HOSTNAME".vgdisplay
fdisk -l >> /tmp/preupgrade/"$HOSTNAME".fdisk
cat /etc/sysctl.conf >> /tmp/preupgrade/"$HOSTNAME".sysctlconf
df -h >> /tmp/preupgrade/"$HOSTNAME".df
cat /etc/profile >> /tmp/preupgrade/"$HOSTNAME".profile
