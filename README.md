![Docker](https://github.com/scjtqs2/nextcloud-docker/workflows/Docker/badge.svg)
## 升级事项
> 添加 NEXTCLOUD_UPDATE=1 环境变量，用于初始化nextcloud文件夹以及自动升级,
>
>不想nextcloud版本随镜像升级，NEXTCLOUD_UPDATE=0 即可
>
> 新版本需要在redis中添加密码，查看最新的docekr-compose.yml中的redis和nc部分即可
> 
> 非alpine的镜像是基于apache的。alpine的镜像是fpm-alpine的，需要nginx配合。
## 解决切换系统后uid/gid不一致导致权限问题（例如apache容器切alpine的php-fpm容器)
> 进入 nc的容器
>
> docker exec -it nextcloud_web /bin/bash
>
> chown -R www-data /var/www/html
>
> chown -R www-data /nextcloud
>
> 这样就会更新成最新的uid和gid了。

## 开始使用
> `git clone https://github.com/scjtqs2/nextcloud-docker.git nextcloud-docker`
>
> `cd nextcloud-docker`
> 
> 修改 .env文件。 修改里面的配置为你自己的配置 
> 
> `docker-compose build` 初始化nginx配置
>
> `docker-compose run --rm db` 进行数据库的初始化。出现 `Database initialized` 标准数据库准备完毕。继续等待 `/usr/sbin/mysqld: ready for connections. Version: '8.0.xx'  socket: '/var/lib/mysql/mysql.sock'  port: 3306  MySQL Community Server - GPL.` 。
> 
> 另开一个命令行窗口。`cd nextcloud-docker`目录。执行 docker-compose down 关闭mysql的初始化进程。
> 
> `docker-compose up -d` 后台会开始静默安装 (nginx打开会502，等待片刻即可)
> 
> `docker-compose logs -f` 查看docker的运行日志。
> 
> 

## occ使用
> 升级到 v19之后，occ web无法使用了，需要使用命令行来操作occ
>
> docker exec --user www-data nextcloud_web php occ

### 使用occ来安装nextcloud
> `docker exec  -u www-data nextcloud_app php occ  maintenance:install --admin-user=admin --admin-pass=admin`
>
> 其他参数 请使用 `docker exec  -u www-data nextcloud_app php occ help maintenance:install` 来查看

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

# 国内镜像地址

> 地址：`registry.cn-hangzhou.aliyuncs.com/scjtqs/nextcloud:[镜像版本号]`
>
> 使用方法：将 `scjtqs/nextcloud:[镜像版本号]` 替换成 `registry.cn-hangzhou.aliyuncs.com/scjtqs/nextcloud:[镜像版本号]` 使用即可
>
> 拉取方法： `sudo docker pull registry.cn-hangzhou.aliyuncs.com/scjtqs/nextcloud:[镜像版本号]`
> 

# PostgreSQL 环境变量配置
- `POSTGRES_DB` Name of the database using postgres.
- `POSTGRES_USER` Username for the database using postgres.
- `POSTGRES_PASSWORD` Password for the database user using postgres.
- `POSTGRES_HOST` Hostname of the database server using postgres.

# mysql 迁移到 PostgreSQL (适用于其他数据库类型迁移)
```bash
docker exec -it -u www-data nextcloud_web bash
# php occ db:convert-type [options] type username hostname database
# type 支持 mysql，oci，pgsql，sqlite3
# php occ db:convert-type --port="5432" --password="password" --clear-schema --all-apps pgsql username  hostname database
php occ db:convert-type --port="5432" --password="nextcloud" --clear-schema --no-interaction --all-apps pgsql nextcloud  postgres nextcloud
```
