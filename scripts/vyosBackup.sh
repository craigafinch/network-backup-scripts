#!/bin/bash
# Should support VyOS-based devices, including Ubiquiti EdgeRouters (EdgeOS)
HOST=$(hostname)
DATE=$(date +'%Y-%m-%d')
BACKUPUSER="my-backup-user"
BACKUPHOST="my-backup-host"

# Assumes that today's directory already exists on the backup host
echo put /config/config.boot | sftp -i /config/user-data/id_rsa_backup -b- "${BACKUPUSER}@${BACKUPHOST}:${HOST}/${DATE}/"