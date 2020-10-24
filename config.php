<?php
//set_time_limit(1200);
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'instanceid' => 'ocnkyaj2whi4',
  'passwordsalt' => 'h+eV69b34G4fr0e5Vu5pTwudNXb/pI',
  'secret' => 'eDpFAbE5W60UxYcFbdsy/KLcPZGC12AxmWYufL4AaLJ7fNxt',
  'trusted_domains' => 
  array (
    0 => '127.0.0.1',
    1 => getenv('NEXTCLOUD_TRUSTED_DOMAINS')?:getenv('DOMAIN'),
  ),
  'datadirectory' => getenv('NEXTCLOUD_DATA_DIR')?:'/nextcloud',
    /**
     * Identifies the database used with this installation. See also config option
     * ``supportedDatabases``
     *
     * Available:
     * 	- sqlite3 (SQLite3)
     * 	- mysql (MySQL/MariaDB)
     * 	- pgsql (PostgreSQL)
     *
     * Defaults to ``sqlite3``
     */
  'dbtype' => getenv('MYSQL_DATABASE')?'mysql':(getenv('POSTGRES_DB')?'pgsql':'sqlite3'),
  'version' => '18.0.10.2',
//  'overwrite.cli.url' => 'https://nc.scjtqs.com:8443',
  'dbname' => getenv('MYSQL_DATABASE')?:(getenv('POSTGRES_DB')?:(getenv('SQLITE_DATABASE')?:'sqlite3')),
  'dbhost' => getenv('MYSQL_HOST')?explode(':',getenv('MYSQL_HOST')[0]):(getenv('POSTGRES_HOST')?:''),
  'dbport' => explode(':',getenv('MYSQL_HOST'))[1]?:(explode(':',getenv('POSTGRES_HOST'))[1]?:getenv('DB_PORT')),
  'dbtableprefix' => 'oc_',
  'dbuser' => getenv('MYSQL_USER')?:(getenv('POSTGRES_USER')?:'') ,
  'dbpassword' => getenv('MYSQL_PASSWORD')?:(getenv('POSTGRES_PASSWORD')?:''),
  'installed' => true,
  'overwriteprotocol' => 'https',
//  'overwrite.cli.url'=>'https://'.getenv('NEXTCLOUD_TRUSTED_DOMAINS')?:getenv('DOMAIN'),
  'loglevel' => 3,
  'default_language' => 'zh_CN',
  'default_locale' => 'zh_Hans_CN',
  'force_language' => 'zh_CN',
  'force_locale' => 'zh_Hans_CN',
    'check_data_directory_permissions' => false,
);
if(!getenv('INSTALLED'))
{
    include_once '/var/www/html/version.php';
    $CONFIG['version']=$OC_Version[0]?:'18.0.10.2';
}
