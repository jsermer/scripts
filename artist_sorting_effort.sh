#!/bin/bash
for i in $(find . -mindepth 2 -maxdepth 2 -type f)
do
   artist=$(mp3info -x -p "%a\n" $i |sed -e "s/'//g" -e 's/ /_/g' -e 's/\//-/g' -e 's/\\/-/g' -e 's/\&/n/g'|tr '[:upper:]' '[:lower:]')
   if [[ ! -z $artist ]]; then
      if [[ ! -d $(dirname $i)/$artist ]]; then
         echo mkdir $(dirname $i)/$artist
      fi
   echo mv $i $(dirname $i)/$artist/.
   fi
done
