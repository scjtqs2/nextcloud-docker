#!/bin/bash

if [ -f ./latest ]; then
    rm latest
fi


#curl -s "https://download.nextcloud.com/server/releases/" | grep ".zip"|grep -v '\.asc' |grep -v '\.md5' |grep -v '\.sha256' |grep -v '\.sha512' |grep -v "latest" |sed 's/<[^>]\+>//g'| sort -u |sed 's/nextcloud-\(.*\).zip\(.*\)/\1/g' >> latest;
curl -fsSL 'https://download.nextcloud.com/server/releases/' \
  |tac|tac| \
	grep -oE 'nextcloud-[[:digit:]]+(\.[[:digit:]]+){2}' | \
	grep -oE '[[:digit:]]+(\.[[:digit:]]+){2}' | \
	sort -uV >> latest;



