<?php
/**
 * Created by IntelliJ IDEA.
 * User: scjtqs
 * Date: 2020-10-24
 * Time: 01:33
 */

$conf=[
    'admin'=>getenv('NEXTCLOUD_ADMIN_USER'),
    'passwd'=>getenv('NEXTCLOUD_ADMIN_PASSWORD'),
    'dir'=>getenv('NEXTCLOUD_DATA_DIR'),
    'dbtype' => getenv('MYSQL_DATABASE')?'mysql':(getenv('POSTGRES_DB')?'pgsql':'sqlite3'),
    'dbname' => getenv('MYSQL_DATABASE')?:(getenv('POSTGRES_DB')?:(getenv('SQLITE_DATABASE')?:'sqlite3')),
    'dbhost' => getenv('MYSQL_HOST')?explode(':',getenv('MYSQL_HOST')[0]):(getenv('POSTGRES_HOST')?:''),
    'dbport' => explode(':',getenv('MYSQL_HOST'))[1]?:(explode(':',getenv('POSTGRES_HOST'))[1]?:getenv('DB_PORT')),
    'dbuser' => getenv('MYSQL_USER')?:(getenv('POSTGRES_USER')?:'') ,
    'dbpassword' => getenv('MYSQL_PASSWORD')?:(getenv('POSTGRES_PASSWORD')?:''),
];

$installshell=<<<EOL
cd /var/www/html
php occ maintenance:install \
--data-dir="{$conf['dir']}" \
--database={$conf['dbtype']} \
--database-name={$conf['dbname']} \
--database-user="{$conf['dbuser']}" \
--database-pass="{$conf['dbpassword']}" \
--admin-user="{$conf['admin']}" \
--admin-pass="{$conf['passwd']}"
echo "Nextcloud version:" 
php occ status
sleep 3
EOL;
$sedShell=<<<EOL
sed -i "s/'installed' =>/#'installed' =>/g" /var/www/html/config/config.php
EOL;

$check=checkInstalled();
if(!$check)
{
    $ret=shell_exec($sedShell);
    print_r($ret);
    shell_exec($installshell);
    print_r($sedShell);
}

function checkInstalled()
{
    require_once   '/var/www/html/lib/versioncheck.php';

    try {

        require_once '/var/www/html/lib/base.php';

        $systemConfig = \OC::$server->getSystemConfig();

        $installed = (bool) $systemConfig->getValue('installed', false);
        $maintenance = (bool) $systemConfig->getValue('maintenance', false);
        # see core/lib/private/legacy/defaults.php and core/themes/example/defaults.php
        # for description and defaults
        $defaults = new \OCP\Defaults();
        $values = [
            'installed'=>$installed,
            'maintenance' => $maintenance,
            'needsDbUpgrade' => \OCP\Util::needUpgrade(),
            'version'=>implode('.', \OCP\Util::getVersion()),
            'versionstring'=>OC_Util::getVersionString(),
            'edition'=> '',
            'productname'=>$defaults->getName(),
            'extendedSupport' => \OCP\Util::hasExtendedSupport()
        ];
        if (OC::$CLI) {
            print_r($values);
        }
        if($installed)
        {
            return true;
        }

    } catch (Exception $ex) {
        http_response_code(500);
        \OC::$server->getLogger()->logException($ex, ['app' => 'remote']);
    }
    return false;
}

