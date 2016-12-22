#!/bin/bash
for filesystem in $(mount |awk '/ext3|reiserfs/ {print $3}')
do
  for filename in $(find $filesystem -type f -size +200000k -xdev)
  do
    echo -e "$(hostname),$(dirname $filename),$(basename $filename)"
  done
done
