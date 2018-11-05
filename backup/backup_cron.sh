#!/bin/bash -e

backup_dir="/var/backups/database/daily"
today=$(date +%Y%m%d)
backup_file="$backup_dir/smr_live_$today.sql"

# cd to root directory of this repository
cd "$(dirname $0)/.."

docker-compose exec -T mysql sh -c 'mysqldump -uroot -p$MYSQL_ROOT_PASSWORD --add-drop-table --add-locks --quote-names --databases smr_live' > $backup_file
bzip2 $backup_file

# Keep only the 30 most recent backups
cd $backup_dir
ls -t1 | sed -e "1,30d" | xargs rm -f