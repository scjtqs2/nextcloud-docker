#!/bin/bash
# Install Nextcloud
print_text_in_color "$ICyan" "Installing Nextcloud..."
cd /var/www/html
nextcloud_occ maintenance:install \
--data-dir="/nextcloud" \
--database=pgsql \
--database-name=nextcloud_db \
--database-user="$NCUSER" \
--database-pass="$PGDB_PASS" \
--admin-user="$NCUSER" \
--admin-pass="$NCPASS"
echo
print_text_in_color "$ICyan" "Nextcloud version:"
nextcloud_occ status
sleep 3
echo