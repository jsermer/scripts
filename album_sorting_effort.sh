#!/bin/bash
while IFS= read -r -d '' file
do
   album=$(mp3info -x -p "%l\n" $file |sed -e "s/'//g" -e 's/ /_/g' -e 's/\//-/g' -e 's/\\/-/g' -e 's/\&/n/g'|tr '[:upper:]' '[:lower:]')
   if [[ ! -z $album ]]; then
      if [[ ! -d $(dirname $file)/$album ]]; then
         echo mkdir "$(dirname $file)"/$album
      fi
   echo mv $file "$(dirname $file)"/$album/.
   fi
done < <(find . -mindepth 3 -maxdepth 3 -type f -print0)
