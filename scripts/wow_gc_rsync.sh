#!/bin/bash

# Define local and remote backup directories
LOCALDIR=/opt/backups
REMOTEDIR=/home/slayo/
REMOTEUSER=slayo
REMOTEHOST=85.193.84.207
SSHKEY=/home/slayo/.ssh/geekconsole_timeweb_rsa

# Define log file
LOGFILE=/home/slayo/logs/rsync.log

# Use rsync to sync the local and remote backup directories
rsync -azP --delete -e "ssh -i $SSHKEY" --log-file=$LOGFILE $LOCALDIR $REMOTEUSER@$REMOTEHOST:$REMOTEDIR

# Check the rsync exit status
if [ $? -eq 0 ]; then
    echo "Rsync completed successfully at $(date)" >> $LOGFILE
else
    echo "Rsync failed at $(date)" >> $LOGFILE
fi