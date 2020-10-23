<?php
/**
 * Created by IntelliJ IDEA.
 * User: scjtqs
 * Date: 2020-10-24
 * Time: 01:33
 */
$curl = curl_init();
$url=(getenv('URL')?:"http://127.0.0.1").'/index.php?INSTALL=2';
curl_setopt_array($curl, array(
    CURLOPT_URL => $url,
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_ENCODING => "",
    CURLOPT_MAXREDIRS => 68,
    CURLOPT_TIMEOUT => 0,
    CURLOPT_FOLLOWLOCATION => true,
    CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
    CURLOPT_CUSTOMREQUEST => "POST",
    CURLOPT_SSL_VERIFYHOST=>2 ,
    CURLOPT_SSL_VERIFYPEER=>false,
    CURLOPT_POSTFIELDS => "install=true&adminlogin=".urlencode(getenv('NEXTCLOUD_ADMIN_USER'))."&adminpass=".urlencode(getenv('NEXTCLOUD_ADMIN_PASSWORD'))."&adminpass-clone=".urlencode(getenv('NEXTCLOUD_ADMIN_PASSWORD')),
    CURLOPT_HTTPHEADER => array(
        "Content-Type: application/x-www-form-urlencoded"
    ),
));

$response = curl_exec($curl);

curl_close($curl);
echo $response;