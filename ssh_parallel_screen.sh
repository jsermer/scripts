#!/usr/bin/screen -L

# connect to all hosts
screen ssh mssnd03
screen ssh mssnd04
screen ssh mssnd05
screen ssh mssnd06

# Don't pause the display just to echo the command
# we're running
msgwait 0

# The 'at' command takes the name of a window as the 1st arg,
# and a GNU Screen command as the 2nd arg.
# The 'stuff' command stuffs keys into the current window's
# keyboard buffer. The ^M at the end is a carat followed by
# an uppercase M; stuff translates that into a carriage return.
at ssh stuff "ps -ef^M"
