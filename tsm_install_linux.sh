#!/bin/bash
if [ $(uname -m) == 'x86_64' ]; then
	rpm -e TIVsm-BA TIVsm-API TIVsm-API64
	rpm --force -Uhv http://10.2.15.21/tsm/linux/TIVsm-API.i386.rpm http://10.2.15.21/tsm/linux/TIVsm-API64.i386.rpm http://10.2.15.21/tsm/linux/TIVsm-BA.i386.rpm
else
	rpm -e TIVsm-BA TIVsm-API
	rpm --force -Uhv http://10.2.15.21/tsm/linux/TIVsm-API.i386.rpm http://10.2.15.21/tsm/linux/TIVsm-BA.i386.rpm
fi
touch /opt/tivoli/tsm/client/ba/bin/dsm.sys
chown 24063:2426 /opt/tivoli/tsm/client/ba/bin/dsm.sys
chmod 644 /opt/tivoli/tsm/client/ba/bin/dsm.sys
touch /opt/tivoli/tsm/client/ba/bin/dsm.opt
chown 24063:2426 /opt/tivoli/tsm/client/ba/bin/dsm.opt
chmod 644 /opt/tivoli/tsm/client/ba/bin/dsm.opt
touch /opt/tivoli/tsm/client/ba/bin/inclexcl.txt
chown 24063:2426 /opt/tivoli/tsm/client/ba/bin/inclexcl.txt
chmod 644 /opt/tivoli/tsm/client/ba/bin/inclexcl.txt
/usr/bin/install -d -g 2426 /opt/tivoli/tsm/logs
chmod g+s /opt/tivoli/tsm/logs
touch /opt/tivoli/tsm/logs/{dsmerror.log,dsmprune.log,dsmsched.log,dsmwebcl.log}
chmod 666 /opt/tivoli/tsm/logs/{dsmerror.log,dsmprune.log,dsmsched.log,dsmwebcl.log}
wget http://10.2.15.21/js/bin/tsm_sched_restart.ksh -O /usr/local/bin/tsm_sched_restart.ksh
chmod 544 /usr/local/bin/tsm_sched_restart.ksh
if ! grep -i suse /proc/version > /dev/null 2>&1; then
	if ! egrep 'tsm_sched|dsmcad' /etc/rc.local > /dev/null 2>&1; then
		echo '/usr/local/bin/tsm_sched_restart.ksh &' >> /etc/rc.local
	fi
else
	if ! egrep 'tsm_sched|dsmcad' /etc/init.d/boot.local > /dev/null 2>&1; then
		echo '/usr/local/bin/tsm_sched_restart.ksh &' >> /etc/init.d/boot.local
	fi
fi
/usr/local/bin/tsm_sched_restart.ksh
if ! grep 'tsm9grp' /etc/sudoers > /dev/null 2>&1; then
	echo -e "\n#TSM Administration Section\n%tsm9grp ALL = /bin/su - tsm9appl\n%tsm9grp ALL = /usr/local/bin/tsm_sched_restart.ksh" >> /etc/sudoers
fi
