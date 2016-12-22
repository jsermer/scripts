#!/bin/sh
FIREFOX=`which firefox`
TO=`echo $1 | sed 's/mailto://'`
## Next 4 lines let you send link from Firefox
SENDLINK=`echo $TO | grep 'body'`
if [ $SENDLINK ] ; then
    TO=`echo $TO | sed -e 's/?/\&/g'`
fi
$FIREFOX "https://mail.google.com/mail?view=cm&tf=0&to=$TO"
