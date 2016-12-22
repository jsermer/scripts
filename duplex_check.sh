#!/bin/bash
/sbin/ip link show | grep UP | awk -F: '/ eth/ {print $2}' | while read interface
do
	if ! ( /usr/sbin/ethtool "$interface" | grep "Duplex: Full" ) > /dev/null 2>&1
	then
		echo "$interface has a duplex mismatch...fixing"
		/usr/sbin/ethtool -s "$interface" autoneg off speed 100 duplex full
		sleep 1
		if ! ( /usr/sbin/ethtool "$interface" | grep "Duplex: Full" ) > /dev/null 2>&1
		then
			echo "$interface is still mismatched...manual intervention necessary"
		else
			echo "$interface now has correct duplex"
		fi
	else
		echo "$interface has correct duplex"
	fi
done
