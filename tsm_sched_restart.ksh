#!/bin/ksh
# Use the following script to kill the currently running instance of the
# TSM scheduler, and restart the scheduler in nohup mode.
#
# This script will not work properly if more than one scheduler process is
# running.

# If necessary, the following variables can be customized to allow an
# alternate options file to be used.
#export DSM_DIR=/opt/tivoli/tsm/client/ba/bin
#export DSM_CONFIG=/opt/tivoli/tsm/client/ba/bin/dsm.opt
#export PATH=$DSM_DIR:$PATH

# Extract the PID for the running TSM Scheduler
PID=$(ps -ef | grep "dsmcad" | grep -v "grep" | awk {'print $2'});
print "Original TSM scheduler process using PID=$PID"

# Kill the scheduler
kill -9 $PID

# Restart the scheduler with nohup, redirecting all output to NULL
# Output will still be logged in the dsmsched.log
nohup dsmcad 2>&1 > /dev/null &

sleep 1

# Extract the PID for the running TSM Scheduler
PID=$(ps -ef | grep "dsmcad" | grep -v "grep" | awk {'print $2'});
print "New TSM scheduler process using PID=$PID"
