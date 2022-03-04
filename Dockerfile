FROM nextcloud:fpm

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

## 安装 oci扩展
RUN set -ex; \
        \
        savedAptMark="$(apt-mark showmanual)"; \
        \
        apt-get update; \
        apt-get install -y --no-install-recommends  \
                unzip \
                libaio* \
                wget \
        ; \
         wget https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-basic-linux.x64-19.14.0.0.0dbru.zip; \
         wget https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-sdk-linux.x64-19.14.0.0.0dbru.zip; \
         mkdir -p /usr/local/webserver/oracle; \
         mv instantclient-* /usr/local/webserver/oracle; \
         cd /usr/local/webserver/oracle; \
         unzip instantclient-basic-linux.x64-19.14.0.0.0dbru.zip; \
         unzip instantclient-sdk-linux.x64-19.14.0.0.0dbru.zip; \
         rm -rf *.zip; \
         mv instantclient_19_14 instantclient; \
         cd instantclient; \
         ln -s /usr/local/webserver/oracle/instantclient/ /usr/local/webserver/oracle/instantclient/lib; \
         mkdir -p include/oracle/11.1; \
         cd include/oracle/11.1; \
         ln -s ../../../sdk/include client; \
         cd - ;\
         mkdir -p lib/oracle/11.1/client; \
         cd lib/oracle/11.1/client; \
         ln -s ../../../ lib; \
         cd - ;\
         mkdir -p /usr/local/webserver/oracle/instantclient/lib/oracle/11.1; \
         ln -s /usr/local/webserver/oracle/instantclient/sdk  /usr/local/webserver/oracle/instantclient/lib/oracle/11.1/client; \
         ln -s /usr/local/webserver/oracle/instantclient  /usr/local/webserver/oracle/instantclient/lib/oracle/11.1/client/lib; \
         mkdir -p /etc/ld.so.conf.d;\
         echo /usr/local/webserver/oracle/instantclient/ | tee -a /etc/ld.so.conf.d/oracle.conf; \
         # PDO_OCI
         export ORACLE_HOME=/usr/local/webserver/oracle/instantclient; \
         export C_INCLUDE_PATH=/usr/local/webserver/oracle/instantclient/sdk/include; \
         export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/webserver/oracle/instantclient:/usr/local/webserver/oracle/instantclient/sdk; \
         #编译
         docker-php-ext-configure oci8 --with-oci8=instantclient,/usr/local/webserver/oracle/instantclient; \
         docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/webserver/oracle/instantclient; \
         #安装
         docker-php-ext-install oci8; \
         docker-php-ext-install pdo_oci; \
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

COPY supervisord.alpine.conf /
COPY a2-tracker.sh /
COPY toucha2.sh /

RUN set -ex; \
        \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        aria2 \
        python3-pip \
        wget \
        curl \
        unrar-free \
        p7zip p7zip-full \
        ; \
        rm -rf /var/lib/apt/lists/* \
        ; \
        pip3 install youtube-dl; \
        ln -s /usr/bin/python3 /usr/bin/python; \
        echo '*/5 * * * * php -f /var/www/html/cron.php' >> /var/spool/cron/crontabs/root; \
        echo '*/5 * * * * curl http://web/cron.php' >> /var/spool/cron/crontabs/root; \
        echo '0 0 1 * * cd / && bash /a2-tracker.sh' >> /var/spool/cron/crontabs/root;

COPY aria2.conf /
# 使用生产环境的php.ini    /usr/local/etc/php/php.ini
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
ENV NEXTCLOUD_UPDATE=1

ENV NLS_LANG="AMERICAN_AMERICA.AL32UTF8"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/webserver/oracle/instantclient:/usr/local/webserver/oracle/instantclient/sdk
ENV ORACLE_HOME=/usr/local/webserver/oracle/instantclient
ENV C_INCLUDE_PATH=/usr/local/webserver/oracle/instantclient/sdk/include

CMD ["/usr/bin/supervisord", "-c", "/supervisord.alpine.conf"]
