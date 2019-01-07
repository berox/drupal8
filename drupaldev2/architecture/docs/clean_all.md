# Clean Up an integration

This must be used only if you want to clean up a integration server
before launch all the scripts, in order to test them from the beginning. 

**WARNING**: This will erase all the website, database, media, ...

+ Remove the packages
```
apt-get purge -y \
 redis-server redis-tools php5-redis \
 mysql-common percona-server-common-5.6 php5-mysql \
 apache2 apache2-bin apache2-data apache2-utils libapache2-mod-php5 \
 php5 php5-cli php5-fpm php5-common php5-curl php5-gd php5-intl php5-json php5-mcrypt php5-readline php5-xsl php5-mhash \
 libvarnishapi1 varnish \
 elasticsearch \
 nginx nginx-common nginx-full \
 npm node-npmlog node-read-package-json javascript-common
```
 
+ Purge the useless packages
```
apt-get autoremove -y --purge
```

+ Verify the packages
```
dpkg -l | grep php
dpkg -l | grep apache
dpkg -l | grep varnish
dpkg -l | grep nginx
dpkg -l | grep redis
dpkg -l | grep mysql
dpkg -l | grep npm
dpkg -l | grep elasticsearch
```

+ Remove files
```
rm -rf /etc/nginx
rm -rf /etc/varnish
rm -rf /etc/apache2
rm -rf /etc/php5
rm -rf /etc/elasticsearch
rm -rf /etc/systemd/system/varnish.service
rm -rf /etc/default/varnish*
rm -rf /var/lib/mysql
rm -rf /var/lib/redis
rm -rf /var/lib/varnish
rm -rf /root/.my.cnf
rm -rf /var/www
```
