#!/bin/bash
#添加以下代码
path=`pwd`/aria2.conf
list=`wget -qO- https://cdn.jsdelivr.net/gh/ngosang/trackerslist/trackers_all_ip.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" $path`" ]; then
    sed -i '$a bt-tracker='${list}  $path
        echo add......
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" $path
    echo update......
fi