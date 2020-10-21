#kintohub.com 的 Dockerfile用法

1、文件选择 Dockerfile.kintohub
2、起一个redis
3、配置环境变量：
```$xslt
      - UPLOAD_MAX_SIZE=10G
      - APC_SHM_SIZE=128M
      - OPCACHE_MEM_SIZE=128
      - CRON_PERIOD=15m
      - TZ=Aisa/Shanghai
      - DOMAIN=wpan.scjtqs.com
      - SQLITE_DATABASE=nextcloud
      - REDIS_HOST=redis-master
      - REDIS_HOST_PORT=6379
      - REDIS_HOST_PASSWORD=你的密码
      - SMTP_HOST=smtp邮箱地址
      - SMTP_PORT=994
      - SMTP_SECURE=ssl
      - SMTP_NAME=邮箱全名地址
      - SMTP_PASSWORD=邮箱密码
      - SMTP_AUTHTYPE=LOGIN
      - MAIL_FROM_ADDRESS=邮箱@前名字
      - MAIL_DOMAIN=邮箱@后域名
      - SWITCH_HTTPS=1
```
