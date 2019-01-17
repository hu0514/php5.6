#!/bin/bash
data_path=/data/php5.6
default_path=/home/php5.6
if [ ! -d ${data_path} ];then
	mkdir -p ${data_path}
	cp ${default_path}/* ${data_path}
	chown -R www:www ${data_path}
	exec /usr/local/php5.6/sbin/php-fpm -y ${data_path}/php-fpm.conf -c ${data_path}/php.ini -F
else
	[ ! -f ${data_path}/php-fpm.conf ] && cp ${default_path}/php-fpm.conf ${data_path}/php-fpm.conf
	[ ! -f ${data_path}/php.ini ] && cp ${default_path}/php.ini ${data_path}/php.ini
	chown -R www:www ${data_path}
	exec /usr/local/php5.6/sbin/php-fpm -y ${data_path}/php-fpm.conf -c ${data_path}/php.ini -F
fi

