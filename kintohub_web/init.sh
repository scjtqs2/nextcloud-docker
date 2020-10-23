#!/bin/bash
curl -X POST http://127.0.0.1/index.php?INSTALL=2 -F "install=true;adminlogin=$NEXTCLOUD_ADMIN_USER;adminpass=$NEXTCLOUD_ADMIN_PASSWORD;adminpass-clone=$NEXTCLOUD_ADMIN_PASSWORD"