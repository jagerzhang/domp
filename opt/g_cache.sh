#!/bin/bash
cd /root;curl -o sitemap.xml https://zhang.ge/sitemap.xml  >/dev/null 2>&1
for url in `egrep -o 'https://zhang.ge([^\<]+)' sitemap.xml`
do
        curl -o /dev/null  $url
        sleep 3
done
