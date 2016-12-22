#!/bin/ksh
#
# check_fs.ksh
#
# script to check for availability and/or percentage used of a filesystem
#

USAGE="
Script to check for availability and/or percentage used of a filesystem

Usage: $0 [-s|-u|-b] filesystem
   -s   check for stale or non-existent filesystems
   -u   check percent usage
   -b   check both
"

if [[ $# -lt 1 ]]; then
	echo "${USAGE}"
	exit 255
elif [[ ! -e /usr/local/etc/check_fs.cfg ]]; then
	echo "\nNo configuration file found.  Please create /usr/local/etc/check_fs.cfg\n"
	exit 255
fi

CFGFILE=/usr/local/etc/$(basename $0 .ksh).cfg
LOGFILE=/usr/local/logs/$(basename $0 .ksh).log

if [[ $(uname -s) = Linux ]]; then
	FSTAB=/etc/fstab
elif [[ $(uname -s) = AIX ]]; then
	FSTAB=/etc/filesystems
fi

exec 1>>$LOGFILE 2>&1

stale () {
	egrep '^[^#]' $CFGFILE | \
	while read FS DEVICE LIMIT
	do
		if grep $FS $FSTAB >/dev/null 2>&1; then
			FSERRORFILE=/usr/local/logs/$(echo $FS | tr '/' '_').fserror
			DEVCHK=$(df -P $FS 2>/dev/null | awk '{print $1}'|tail -1)
			df -P $FS >/dev/null 2>&1
			RC=$?
			if [[ ( $RC -ne 0 ) && ( ! -e $FSERRORFILE ) ]]; then
				echo "$(date +"%D-%H:%M:%S"): Filesystem Availability Alert - $FS appears to be stale!"
				touch $FSERRORFILE
			elif [[ ( $DEVCHK != $DEVICE ) && ( ! -e $FSERRORFILE ) ]]; then
				echo "$(date +"%D-%H:%M:%S"): Filesystem Availability Alert - $FS appears to be unmounted!"
				touch $FSERRORFILE
			elif [[ ( $RC -eq 0 ) && ( $DEVCHK = $DEVICE ) && ( -e $FSERRORFILE ) ]]; then
				echo "$(date +"%D-%H:%M:%S"): Filesystem Availability Alert - $FS appears to be OK"
				rm $FSERRORFILE
			fi
		fi
	done
}

percent_usage () {
	egrep '^[^#]' $CFGFILE | \
	while read FS DEVICE LIMIT
	do
		if grep $FS $FSTAB >/dev/null 2>&1; then
			UTILERRORFILE=/usr/local/logs/$(echo $FS | tr '/' '_').utilerror
			DEVCHK=$(df -P $FS 2>/dev/null | awk '{print $1}'|tail -1)
			PERUTIL=$(df -P $FS 2>/dev/null| tail -1 | awk '{print $5}' | tr -d "%")
			if [[ ( $PERUTIL -ge $LIMIT ) && ( $DEVCHK = $DEVICE ) && ( ! -e $UTILERRORFILE ) ]]; then
				echo "$(date +"%D-%H:%M:%S"): Filesystem Space Alert - $FS is at $PERUTIL% (utilization is equal to or above threshold of $LIMIT%)"
				touch $UTILERRORFILE
			elif [[ ( $PERUTIL -lt $LIMIT ) && ( $DEVCHK = $DEVICE ) && ( -e $UTILERRORFILE ) ]]; then
				echo "$(date +"%D-%H:%M:%S"): Filesystem Space Alert - $FS is at $PERUTIL% (utilization is under threshold of $LIMIT%)"
				rm $UTILERRORFILE
			fi
		fi
	done
}

case "$*" in
	-s) stale ;;
	-u) percent_usage ;;
	-b) stale
	percent_usage ;;
	*) echo "${USAGE}"
	exit 255
	;;
esac
