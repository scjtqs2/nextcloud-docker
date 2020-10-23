<?php
$CONFIG = array (
  'htaccess.RewriteBase' => '/',
  'instanceid' => 'd3c944a9a',
  'passwordsalt' => 'd3c944a9af095aa08f',
  'secret' => 'd3c944a9af095aa08f',
  'trusted_domains' => 
  array (
    0 => getenv('DOMAIN'),
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
  'dbhost' => getenv('MYSQL_HOST')?:(getenv('POSTGRES_HOST')?:''),
  'dbport' => getenv('DB_PORT')?:'',
  'dbtableprefix' => 'oc_',
  'dbuser' => getenv('MYSQL_USER')?:(getenv('POSTGRES_USER')?:'') ,
  'dbpassword' => getenv('MYSQL_PASSWORD')?:(getenv('POSTGRES_PASSWORD')?:''),
  'installed' => getenv('INSTALLED')?true:false,
  'overwriteprotocol' => 'https',
  'maintenance' => false,
  'loglevel' => 3,
  'default_language' => 'zh_CN',
  'default_locale' => 'zh_Hans_CN',
  'force_language' => 'zh_CN',
  'force_locale' => 'zh_Hans_CN',
);
if(!getenv('INSTALLED'))
{
    include_once '/var/www/html/version.php';
    $CONFIG['version']=$OC_Version[0]?:'18.0.10.2';
}
