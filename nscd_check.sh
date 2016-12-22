#!/bin/bash
if ! pgrep -f /usr/sbin/nscd > /dev/null 2>&1; then
	date >> /tmp/nscd_restart.log
	echo "nscd appears dead.....restarting" >> /tmp/nscd_restart.log
	/etc/init.d/nscd restart > /dev/null 2>&1
fi
