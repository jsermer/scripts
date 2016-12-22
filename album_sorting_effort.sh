#!/bin/bash
for i in $(find . -mindepth 3 -maxdepth 3 -type f)
do
   album=$(mp3info -x -p "%l\n" $i |sed -e "s/'//g" -e 's/ /_/g' -e 's/\//-/g' -e 's/\\/-/g' -e 's/\&/n/g'|tr '[:upper:]' '[:lower:]')
   if [[ ! -z $album ]]; then
      if [[ ! -d $(dirname $i)/$album ]]; then
         echo mkdir $(dirname $i)/$album
      fi
   echo mv $i $(dirname $i)/$album/.
   fi
done
