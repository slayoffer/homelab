#!/bin/bash

# Define the source directory and the backup directory
SOURCE_DIR="/home/slayo/docker/wow-x10"
BACKUP_DIR="/opt/backups"
DAYS=1

# Get the current date and time to append to the backup filename
DATE=$(date +"%Y%m%d-%H%M%S")

# Create the backup filename with date and time
BACKUP_FILENAME="wow-x10-backup-$DATE.tar.gz"

# Create a GZIP compressed tar archive of the source directory
sudo tar -czf "$BACKUP_DIR/$BACKUP_FILENAME" "$SOURCE_DIR"

# Delete backups older than DAYS
sudo find $BACKUPDIR -name "wow-x10-backup*tar.gz" -daystart -mtime +$DAYS -delete

echo "Backup of $SOURCE_DIR completed and stored as $BACKUP_DIR/$BACKUP_FILENAME"