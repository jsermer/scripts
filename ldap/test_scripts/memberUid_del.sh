#!/bin/bash
(awk '/^memberUid:/ {print $2}' $1|sed 's/\r//') | while read i
do
	if ! grep -i "^member:.*${i}$" $1 >/dev/null; then
		echo -e "dn: cn=$(basename $1 .txt),o=Associates\nchangetype: modify\ndelete: memberUid\nmemberUid: ${i}\n"
	fi
done

