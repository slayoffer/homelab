#!/bin/bash

# DB Container Backup Script Template
DAYS=1
BACKUPDIR=/opt/backups/
MSQL_ROOT_PWD="password"
DB_CONTAINER=ac-database-individual

# Define local and remote backup directories
LOCALDIR=/opt/backups
REMOTEDIR=/home/slayo/
REMOTEUSER=slayo
REMOTEHOST=185.196.117.196
SSHKEY=/home/slayo/.ssh/geekconsole_timeweb_rsa

# Define log file
LOGFILE=/home/slayo/logs/rsync.log

# Get list of databases
DBS="$(docker exec $DB_CONTAINER mysql -u root -p$MSQL_ROOT_PWD -Bse 'show databases')"

for db in $DBS; do
    # Skip certain databases
    if [ "$db" == "information_schema" ] || [ "$db" == "performance_schema" ] || [ "$db" == "mysql" ] || [ "$db" == "sys" ]; then
        continue
    fi

    # Dump and compress each database
    cd ~/dev/scripts
    sudo docker exec $DB_CONTAINER /usr/bin/mysqldump -u root -p$MSQL_ROOT_PWD --databases $db > wow-ind-$db-$(date +"%Y%m%d%H").sql
    sudo gzip wow-ind-$db-$(date +"%Y%m%d%H").sql
    sudo mv wow-ind-$db-$(date +"%Y%m%d%H").sql.gz $BACKUPDIR
done

# Delete backups older than DAYS
sudo find $BACKUPDIR -name "*.sql.gz" -daystart -mtime +$DAYS -delete
sudo find $BACKUPDIR -name "*.tar.gz" -daystart -mtime +$DAYS -delete

# Use rsync to sync the local and remote backup directories
rsync -azP --delete -e "ssh -i $SSHKEY -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" --log-file=$LOGFILE $LOCALDIR $REMOTEUSER@$REMOTEHOST:$REMOTEDIR

# Check the rsync exit status
if [ $? -eq 0 ]; then
    echo "Rsync completed successfully at $(date)" >> $LOGFILE
else
    echo "Rsync failed at $(date)" >> $LOGFILE
fi
