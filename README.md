## 开始使用
> git clone https://github.com/scjtqs/nextcloud-docker.git nextcloud-docker

> cd nextcloud-docker

> docker-compose up -d


## 关闭

> docker-compose down

## docker for win 注意事项

> 需要在nextcloud/config/config.php中增加一个配置项

> `'check_data_directory_permissions' => false,`     #检查数据目录权限

> docker-compose.yml中对应的目录地址，请全部修改为win下对应的本地目录地址

## 一些默认参数

> nextcloud安装时的数据库地址，将“localhost”改成db,用户root，密码root。

> nginx 的反向代理配置需要自己写了，我这里就没有预制了。

## 关于使用 nginx 反向代理nextcloud自带的apache并对外使用https的一些建议：

> 请在config.php中添加一行 `'overwriteprotocol' => 'https',`

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
#        proxy_redirect off;
          proxy_pass http://asus:9080;
         proxy_set_header Host $http_host;
         proxy_set_header X-Forwarded-Proto $scheme;
         proxy_set_header X-Real-IP $remote_addr;
         proxy_set_header Upgrade $http_upgrade;
         proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
 }

````
