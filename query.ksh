for i in $(grep -v ^# suse.lst )
do
	echo $i
	ssh -q $i 'hostname'
done
