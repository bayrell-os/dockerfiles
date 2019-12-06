FROM bayrell/centos7_repos:latest

RUN cd ~; \
	echo "[1] Install packages"; \
	yum install -y nginx nodejs yarn php71 php71-php-fpm php71-php-mbstring php71-php-pecl-memcached php71-php-intl php71-php-opcache php71-php-pdo php71-php-pgsql php71-php-mysqlnd php71-php-gd php71-php-json php71-php-xml php71-php-pecl-zip php71-php-pecl-mongodb php71-php-pecl-mysql php71-php-tarantool php71-php-soap; \
	yum clean all; \
	ln -s /usr/bin/php71 /usr/bin/php; \
	ln -s /usr/bin/php71-cgi /usr/bin/php-cgi; \
	groupadd -r -g 800 www; \
	useradd -r -M -g 800 -u 800 www; \
	usermod -a -G www nginx; \
	echo "Ok"

RUN cd ~; \
	echo "[2] Settings PHP"; \
	sed -i "s|;date.timezone =.*|date.timezone = UTC|g" /etc/opt/remi/php71/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/opt/remi/php71/php.ini; \	
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/opt/remi/php71/php.ini; \	
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/opt/remi/php71/php.ini; \	
	sed -i "s|listen =.*|listen = /var/run/php71-fpm.sock|g" /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i "s|;listen.owner =.*|listen.owner = www|g" /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i "s|;listen.group =.*|listen.group = www|g" /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i "s|;listen.mode =.*|listen.mode = 0660|g" /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's|user = .*|user = www|g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's|group = .*|group = www|g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/opt/remi/php71/php-fpm.d/www.conf; \	
	sed -i 's|php_value\[session.save_path\].*|php_value[session.save_path] = /data/php/session|g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's|php_value\[soap.wsdl_cache_dir\].*|php_value[soap.wsdl_cache_dir] = /data/php/wsdlcache|g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	echo "php_admin_value[memory_limit] = 128M" >> /etc/opt/remi/php71/php-fpm.d/www.conf; \
	echo "php_admin_value[post_max_size] = 128M" >> /etc/opt/remi/php71/php-fpm.d/www.conf; \
	echo "php_admin_value[file_uploads] = on" >> /etc/opt/remi/php71/php-fpm.d/www.conf; \
	echo "php_admin_value[upload_tmp_dir] = /tmp" >> /etc/opt/remi/php71/php-fpm.d/www.conf; \
	echo "php_admin_value[precision] = 16" >> /etc/opt/remi/php71/php-fpm.d/www.conf; \
	echo "php_admin_value[max_execution_time] = 30" >> /etc/opt/remi/php71/php-fpm.d/www.conf; \
	ln -sf /dev/stdout /var/log/nginx/access.log; \
	ln -sf /dev/stdout /var/log/nginx/error.log; \
	ln -sf /dev/stdout /var/opt/remi/php71/log/php-fpm/error.log; \
	chown -R www:www /var/opt/remi/php71/log/php-fpm; \
	echo "Ok"
	
ADD files /src/files
RUN cd ~; \
	yes | cp -rf /src/files/* /; \
	chmod +x /root/run.sh; \
	echo "Ok"
	