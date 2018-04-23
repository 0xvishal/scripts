#!/bin/bash
# Full backup of a server  with database, run this script once in a day 
# Copyright (c) 2015-2018 Vishal Gupta
# Automatically generated backups by Vishal Gupta
# EMAILID="er.vishalkumargupta@gmail.com"
# ---------------------------------------------------------------------

# Yesterday date
YES_DAY=$(date -d '01 days ago' +'%d-%m-%Y')

# Remove yesterday backup from vishal
rmv='rm -r /home/vishal/public_html/backup/'$YES_DAY''
$rmv
# Yesterday date
NOW=$(date +"%d-%m-%Y")
BACKUP=/home/vishal/public_html/backup/$NOW
### MySQL Setup ###
MUSER="vishal"
MPASS="s2kfb4ed2gt4a1v9"
MHOST="localhost"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"

# Create directries for for backup
[ ! -d $BACKUP ] && mkdir $BACKUP mkdir $BACKUP/database

# Find all databases and take backup in $BACKUP/database
DBS="$($MYSQL -u $MUSER -h $MHOST -p$MPASS -Bse 'show databases')"
for db in $DBS
do
echo $db
  $MYSQLDUMP -u $MUSER -h $MHOST -p$MPASS $db > "$BACKUP"/database/"$db".sql
 done

 # Path of all directries those have to take backup
 DIRS="/home/vishal/public_html/emailtest /home/vishal/public_html/india-calling /home/vishal/public_html/wp-admin /home/vishal/public_html/featurette /home/vishal/public_html/xml /home/vishal/public_html/gosbeta /home/vishal/public_html/wp-includes /home/vishal/public_html/app /home/vishal/public_html/responsive-audio-player /home/vishal/public_html/urdu_cuesheet /home/vishal/public_html/wp-content /home/vishal/public_html/cuesheet $BACKUP/database"

# name of the backup file 
FILE="fs-full-$NOW.tar.gz"
# Compress all selected directries with tar
tar -zcvf $BACKUP/$FILE $DIRS

