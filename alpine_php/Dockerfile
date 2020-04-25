FROM bayrell/alpine:latest

RUN cd ~; \
	apk update; \
	apk add php7 php7-fpm php7-json php7-mbstring php7-openssl nginx; \
	rm -rf /var/cache/apk/*; \
	addgroup -g 800 -S www; \
	adduser -D -H -S -G www -u 800 www; \
	adduser nginx www; \
	chown -R www:www /var/log/nginx; \
	echo "Ok"
	
RUN cd ~; \
	sed -i "s|;date.timezone =.*|date.timezone = UTC|g" /etc/php7/php.ini; \
	sed -i "s|short_open_tag =.*|short_open_tag = On|g" /etc/php7/php.ini; \	
	sed -i "s|display_errors =.*|display_errors = On|g" /etc/php7/php.ini; \	
	sed -i "s|error_reporting =.*|display_errors = E_ALL|g" /etc/php7/php.ini; \	
	sed -i "s|listen =.*|listen = /var/run/php-fpm.sock|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|;listen.owner =.*|listen.owner = www|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|;listen.group =.*|listen.group = www|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|;listen.mode =.*|listen.mode = 0660|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|user = .*|user = www|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|group = .*|group = www|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|;clear_env =.*|clear_env = no|g" /etc/php7/php-fpm.d/www.conf; \	
	sed -i "s|php_value\[session.save_path\].*|php_value[session.save_path] = /data/php/session|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|php_value\[soap.wsdl_cache_dir\].*|php_value[soap.wsdl_cache_dir] = /data/php/wsdlcache|g" /etc/php7/php-fpm.d/www.conf; \
	sed -i "s|;php_admin_value\[error_log\].*|php_admin_value[error_log] = /var/log/nginx/php_error.log|g" /etc/php7/php-fpm.d/www.conf; \
	echo "php_admin_value[memory_limit] = 128M" >> /etc/php7/php-fpm.d/www.conf; \
	echo "php_admin_value[post_max_size] = 128M" >> /etc/php7/php-fpm.d/www.conf; \
	echo "php_admin_value[file_uploads] = on" >> /etc/php7/php-fpm.d/www.conf; \
	echo "php_admin_value[upload_tmp_dir] = /tmp" >> /etc/php7/php-fpm.d/www.conf; \
	echo "php_admin_value[precision] = 16" >> /etc/php7/php-fpm.d/www.conf; \
	echo "php_admin_value[max_execution_time] = 30" >> /etc/php7/php-fpm.d/www.conf; \	
	ln -sf /dev/stdout /var/log/nginx/access.log; \
	ln -sf /dev/stdout /var/log/nginx/error.log; \
	ln -sf /dev/stdout /var/log/nginx/php_error.log; \
	ln -sf /dev/stdout /var/log/php7/error.log; \
	echo "Ok"
	
ADD files /src/files
RUN cd ~; \
	rm -f /etc/nginx/conf.d/default.conf; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/var/* /var/; \
	rm -rf /src/files; \
	chmod +x /root/run.sh; \
	echo "Ok"	
	
CMD ["/root/run.sh"]