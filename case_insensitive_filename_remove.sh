#!/bin/bash
removed=0
diff=0
for i in $(find . -type f); do
	j=$(echo $i |tr '[:upper:]' '[:lower:]')
	if [[ $i != "$j" ]]; then
		if [[ -f $j ]]; then
			if ! diff $i $j > /dev/null 2>&1; then
				diff=$(expr $diff + 1)
			else
				echo "removing $i"
				#echo "rm $i"
				removed=$(expr $removed + 1)
			fi
		fi
	fi
done
echo "unique files with same name: " $diff
echo "number of files removed: " $removed
