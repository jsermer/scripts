#!/bin/bash
musicroot=/data/mp3
symlinkdir=alphabet
cd $musicroot/$symlinkdir
for letter in 0 1 2 3 4 5 6 7 8 9 a b c d e f g h i j k l m n o p q r s t u v w x y z
do
	#test if it's an integer
	if [ $letter -eq $letter 2>/dev/null ]; then
		cd 0-9
	else
		cd $letter
	fi

	for src in $(ls -1d ../../unsorted/${letter}* 2>/dev/null)
	do
		dest=$(basename $src)
		if [ ! -L $dest ]; then
			ln -s $src $dest
		fi
	done
	cd $musicroot/$symlinkdir
done

if [ -e /usr/bin/symlinks ]; then
	/usr/bin/symlinks -rt $musicroot/$symlinkdir | awk '/^dangling/ {print $2}'|xargs -i rm {}
else
	echo -e "\nERROR:  Please install symlinks package!\n"
fi
