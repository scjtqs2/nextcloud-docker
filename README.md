## 开始使用
> git clone https://github.com/scjtqs/nextcloud-docker.git nextcloud-docker

> cd nextcloud-docker

> docker-compose up -d

## 薪资fpm-alpine版本

> 使用 docker-compose-fpm.yml

## 使用http代理 fq

> 在 config.php里面加入一行：

```
'proxy' => '192.168.0.2:10809',
```

> ip+端口的形式，不需要带上http头。需要使用http的代理。

## 中文和时区问题：

> 在 config.php中加入:

```
  "default_language" => "zh_CN",
  "default_locale" => "zh_Hans_CN",
  "force_language" => "zh_CN",
  "force_locale" => "zh_Hans_CN",
```

## 关闭

> docker-compose down

## docker for win 注意事项

> 需要在nextcloud/config/config.php中增加一个配置项

> `'check_data_directory_permissions' => false,`     #检查数据目录权限

> docker-compose.yml中对应的目录地址，请全部修改为win下对应的本地目录地址

## 将nextcloud-data挂载成smb(from windows)的时候需要注意事项
> > 需要在nextcloud/config/config.php中增加一个配置项

> `'check_data_directory_permissions' => false,`     #检查数据目录权限

> 在/etc/fstab 中的挂载参数加上 `dir_mode=0777,file_mode=0777` 例如：

> `//10.0.0.2/floder_e /mnt/ssd/nextcloud-docker/nextcloud-data   cifs    defaults,username=scjtqs,password=scjtqs,dir_mode=0777,file_mode=0777 0 2`

> 事后记得在 nextcloud-data 下 `touch nextcloud-data/aria2.session && touch nextcloud-data/aria2.log` 这两个是aria2启动的必须文件

## 一些默认参数

> nextcloud安装时的数据库地址，将“localhost”改成db,用户root，密码root。

> nginx 的反向代理配置需要自己写了，我这里就没有预制了。

## 关于使用 nginx 反向代理nextcloud自带的apache并对外使用https的一些建议：

需要在nextcloud/config/config.php加入一个https跳转

> `'overwriteprotocol' => 'https',`

以及如下部分

> `'overwrite.cli.url' => 'https://your.domain.com:8443',`//此处写上完整的对外域名

### nginx 反向代理的部分片段
````nginx
   location = /.well-known/carddav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }
    location = /.well-known/caldav {
      return 301 $scheme://$host:$server_port/remote.php/dav;
    }
location / {
        proxy_http_version 1.1;
        proxy_redirect off;
        proxy_pass http://182.168.50.127:9080/;
        proxy_set_header   Host $host;
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Host $server_name;
        proxy_set_header   X-Forwarded-Proto https;
	proxy_set_header Upgrade $http_upgrade;
        access_log      /var/log/nginx/nextcloud.access.log;
        error_log       /var/log/nginx/nextcloud.error.log;
        proxy_read_timeout  120s;
        client_max_body_size 512M;
        proxy_request_buffering off;
 }

````
# 更新aria2c的bt-tracker
> cd nextcloud-docker
>
> ./a2-tracker.sh
>
> 然后重启docker容器。当前，请确保docker-compose.yml里面已经映射了aria2.conf到docker镜像（默认已映射）

#  国内很多插件无法直接下载
> 因此我上传了一个常用插件打包custom_apps.tar.gz
> 
> 直接解压到nextcloud文件夹下，替换/融合 custom_apps文件夹即可

# 升级流程
> docker-compose 升级镜像真tm方便：
>
> 1、docker-compose down 停止服务
>
> 2、docker-compose pull 更新image
>
> 3、docker-compose up -d 启动服务
>
> 3、docker image prune 删除旧的镜像
