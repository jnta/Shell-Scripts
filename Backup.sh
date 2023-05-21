#!/usr/bin/env sh

# Backup directory
backup_path="$HOME/Documents"

# Destination directory
external_storage="/mnt/backup"

# File formatting
date_format=$(date "+%d-%m-%Y")
final_file="backup-$date_format.tar.gz"

#Log
log_file="/var/log/daily-backup.log"

##############################
# Tests
##############################
# Check mount
if ! mountpoint -q -- $external_storage; then
  printf "[$date_format] DEVICE NOT MOUNTED in: $external_storage CHECK IT.\n" >> $log_file
  exit 1
fi

##############################
# Backup
##############################
if tar -czSpf "$external_storage/$final_file" "$backup_path"; then
  printf "[$date_format] BACKUP SUCCESS.\n" >> $log_file
else
  printf "[$date_format] BACKUP ERROR.\n" >> $log_file
fi
  
# Delete backups older than 10 days
find $external_storage -mtime +10 -delete
