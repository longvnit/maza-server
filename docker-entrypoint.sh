#!/bin/bash

if [ ! -d /home/maza ]; then
	# make dir
	mkdir -p /home/maza/domains/maza.dev/public_html
	mkdir -p /home/maza/domains/oms.maza.dev/public_html
	mkdir -p /home/maza/domains/sys.maza.dev/public_html

	# Change Owner
	chown maza.maza -R /home/maza

	# Chmod 755
	chmod 755 /home/maza
fi

# Make PHP-FPM
if [ ! -e /webserver/php/etc/fpm.d/maza.conf  ]; then
	cp /webserver/php/etc/fpm.d/www.conf /webserver/php/etc/fpm.d/maza.conf
	sed -i 's/www/maza/g' /webserver/php/etc/fpm.d/maza.conf
	sed -i 's/php-fpm.sock/php-fpm-maza.sock/g' /webserver/php/etc/fpm.d/maza.conf
fi

# FIX PHP ERROR DISPLAY
sed -i 's/display_errors = Off/display_errors = On/g' /webserver/php/etc/php.ini

# MAKE APACHE CONF
if [ ! -e /webserver/apache/conf/extra/vhost/maza.dev.conf ]; then
	cd /webserver/apache/conf/extra/vhost
	cp domain.conf.template maza.dev.conf
	sed -i 's/<USER>/maza/g' maza.dev.conf
	sed -i 's/<DOMAIN>/maza.dev/g' maza.dev.conf
	sed -i 's/maza.sock/maza.sock -idle-timeout 300/g' maza.dev.conf
	
	# Replace Log
	sed '/CustomLog/d' maza.dev.conf | sed '/ErrorLog/d' > temp.txt
	rm -rf maza.dev.conf
	mv temp.txt maza.dev.conf

	cp maza.dev.conf oms.maza.dev.conf
	sed -i 's/maza.dev/oms.maza.dev/g' oms.maza.dev.conf
	sed -i '/FastCgiExternalServer/d' oms.maza.dev.conf
	sed -i 's/oms.maza.dev\/cgi-bin/maza.dev\/cgi-bin/g' oms.maza.dev.conf
	cp maza.dev.conf sys.maza.dev.conf
	sed -i 's/maza.dev/sys.maza.dev/g' sys.maza.dev.conf
	sed -i '/FastCgiExternalServer/d' sys.maza.dev.conf
	sed -i 's/sys.maza.dev\/cgi-bin/maza.dev\/cgi-bin/g' sys.maza.dev.conf
fi

# RECONFIG APACHE
SERVER_NAME=`cat /webserver/apache/conf/httpd.conf | grep ServerName`
HOST_NAME=`hostname`
if [ "$SERVER_NAME" == "" ]; then
	sed -i "/Listen 80/a ServerName $HOST_NAME" /webserver/apache/conf/httpd.conf
fi

# cd maza root
cd /home/maza

# Start Service
/etc/init.d/httpd start
/etc/init.d/php-fpm start

exec "$@"
