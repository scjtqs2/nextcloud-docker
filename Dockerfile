FROM nextcloud:18-apache

#RUN sed -i 's/deb.debian.org/mirror.sjtu.edu.cn/g' /etc/apt/sources.list
#RUN sed -i 's/security.debian.org/mirror.sjtu.edu.cn/g' /etc/apt/sources.list

RUN set -ex; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        libmagickcore-6.q16-6-extra \
        procps \
        smbclient \
        supervisor \
#       libreoffice \
    ; \
    rm -rf /var/lib/apt/lists/*

RUN set -ex; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        libbz2-dev \
        libc-client-dev \
        libkrb5-dev \
        libsmbclient-dev \
    ; \
    \
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl; \
    docker-php-ext-install \
        bz2 \
        imap \
    ; \
    pecl install smbclient; \
    docker-php-ext-enable smbclient; \
    \
# reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false; \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
    /var/log/supervisord \
    /var/run/supervisord \
;

COPY supervisord.conf /
COPY a2-tracker.sh /

RUN apt-get update; \
        apt-get install -y --no-install-recommends \
        aria2 \
        python-pip \
        ; \
        pip install youtube-dl; \
        rm -rf /var/lib/apt/lists/* ; \
        echo '*/5 * * * * php -f /var/www/html/cron.php \r\n' >> /var/spool/cron/crontabs/root; \
        echo '*/5 * * * * curl http://127.0.0.1/cron.php \r\n' >> /var/spool/cron/crontabs/root; \
        echo '*/5 * * * * cd / && bash /a2-tracker.sh \r\n' >> /var/spool/cron/crontabs/root;
        
COPY aria2.conf /

ENV NEXTCLOUD_UPDATE=0

CMD ["/usr/bin/supervisord", "-c", "/supervisord.conf"]
