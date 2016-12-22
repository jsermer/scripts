#!/bin/bash
(awk -F\= '/^member:/ {print $2}' $1|sed 's/,o$//') | while read i
do
	if ! grep -i "^memberUid:.*${i}$" $1 >/dev/null; then
		echo -e "dn: cn=$(basename $1 .txt),o=Associates\nchangetype: modify\nadd: memberUid\nmemberUid: $(echo ${i} | tr 'A-Z' 'a-z')\n"
	fi
done

