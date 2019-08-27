#!/bin/bash
# Create a date-stamped subdirectory for each device in the backup directory

BACKUPUSER="backupuser"
BACKUPPATH="/srv/sftp/${BACKUPUSER}/home/${BACKUPUSER}"
BACKUPGROUP=$BACKUPUSER

cd $BACKUPPATH && for dir in ./*; do
	DIRNAME=`date +\%Y-\%m-\%d`;
	mkdir $dir/$DIRNAME;
	chown $BACKUPUSER.$BACKUPGROUP $dir/$DIRNAME;
done

# The following line is only required if another user needs to read the files
# -- for example, another application might back up all the files offsite
# chmod -R +r $BACKUPPATH