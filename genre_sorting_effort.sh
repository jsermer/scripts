#!/bin/bash
for i in $(find . -maxdepth 1 -type f)
do
   genre=$(mp3info -x -p "%g\n" $i |sed -e "s/'//g" -e 's/ /_/g' -e 's/\//-/g' -e 's/\\/-/g' -e 's/\&/n/g'|tr '[:upper:]' '[:lower:]')
   if [[ ! -z $genre ]]; then
      if [[ ! -d $(dirname $i)/$genre ]]; then
         echo mkdir $(dirname $i)/$genre
      fi
   echo mv $i $(dirname $i)/$genre/.
   fi
done
