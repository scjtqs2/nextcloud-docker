## 开始使用
> git clone https://github.com/scjtqs/nextcloud-docker.git nextcloud-docker

> cd nextcloud-docker

> docker-compose up -d

## 关闭

> docker-compose down

## docker for win 注意事项

> 需要在nextcloud/config/config.php中增加一个配置项

> 'check_data_directory_permissions' => false,     #检查数据目录权限

> docker-compose.yml中对应的目录地址，请全部修改为win下对应的本地目录地址
