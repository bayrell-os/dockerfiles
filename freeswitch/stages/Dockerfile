FROM bayrell/centos7_repos:latest


ADD install /src/install/
ADD fusionpbx /src/fusionpbx/


RUN cd ~; \
	
	echo "[1] Install common programs"; \
	yum update -y; \
	yum install -y mc nano htop supervisor sudo git ca-certificates ntp htop net-tools vim openssl; \
	yum install -y ghostscript libtiff-devel libtiff-tools at less; \
	yum install -y memcached curl gdb man sysvinit-tools lsof; \
	
	
	
	echo "[2] Install freeswitch"; \
	rpm --import /src/install/download/RPM-GPG-KEY-FREESWITCH; \
	yum install -y /src/install/download/freeswitch-release-1-6.noarch.rpm; \
	yum install -y freeswitch-config-vanilla freeswitch-lang-* freeswitch-sounds-*; 
	
	
	
RUN cd ~; \	
	
	echo "[3] Install Fusion PBX"; \
	rpm -Uvh /src/install/download/cert-forensics-tools-release-el7.rpm; \
	yum install -y lame; \
	mv /etc/freeswitch /etc/freeswitch.orig; \
	mkdir /etc/freeswitch; \
	mkdir -p /var/run/freeswitch; \
	cp -R /src/fusionpbx/resources/templates/conf/* /etc/freeswitch; \
	
	usermod -a -G daemon freeswitch; \
	chown -R freeswitch:daemon /etc/freeswitch; \
	chown -R freeswitch:daemon /usr/share/freeswitch; \
	chown -R freeswitch:daemon /var/lib/freeswitch; \
	chown -R freeswitch:daemon /var/log/freeswitch; \
	chown -R freeswitch:daemon /var/run/freeswitch; \
	chown -R freeswitch:daemon /src/fusionpbx; \
	find /src/fusionpbx -type d -exec chmod 775 {} +; \
	find /src/fusionpbx -type f -exec chmod 664 {} +; \
	
	echo "[4] Install sngrep"; \
	rpm --import /src/install/download/IRONTEC; \
	cp -fv /src/install/irontec.repo /etc/yum.repos.d/irontec.repo; \
	yum install -y sngrep;
	
	
	
RUN cd ~; \	
	
	echo "[5] Install PHP 5.6"; \
	yum install -y php56 php56-php-fpm php56-php-gd php56-php-pgsql php56-php-odbc php56-php-imap php56-php-mcrypt php56-php-opcache php56-php-common php56-php-pdo php56-php-soap php56-php-xml php56-php-xmlrpc php56-php-cli; \	
	sed -i "s#;date.timezone =#date.timezone = Asia/Almaty#g" /etc/opt/remi/php56/php.ini; \
	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/opt/remi/php56/php.ini; \
	sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9056|g" /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/;listen.owner = nobody/listen.owner = nobody/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/;listen.group = nobody/listen.group = nobody/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/user = apache/user = freeswitch/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/group = apache/group = daemon/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's#php_value\[session.save_path\].*#php_value[session.save_path] = /var/run/session#g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	mkdir -p /var/run/session; \
	mkdir -p /var/run/php-fpm; \
	chmod -R 770 /var/run/session; \
	chown freeswitch:daemon /var/run/session; \
	ln -s /usr/bin/php56 /usr/bin/php; \
	ln -s /usr/bin/php56-cli /usr/bin/php-cli; \
	ln -s /usr/bin/php56-cgi /usr/bin/php-cgi; \
	
	
	echo "[6] Install NGINX"; \	
	yum install -y nginx; \
	cp /src/install/nginx-fusionpbx.conf /etc/nginx/conf.d/fusionpbx.conf; \
	rm -f /etc/nginx/nginx.conf; \
	cp -f /src/install/nginx.conf /etc/nginx/nginx.conf; 
	
	
	
RUN cd ~; \	
	
	echo "[7] Install Postgre SQL"; \	
	rpm -Uvh /src/install/download/pgdg-centos94-9.4-3.noarch.rpm; \
	yum -y install postgresql94-server postgresql94-contrib postgresql94; 
	
	
	
RUN cd ~; \	
	
	echo "[8] Create folders"; \
	mkdir -p /data; \
	mkdir -p /src/data/etc; \
	mkdir -p /src/data/lib; \
	mkdir -p /var/run/dbus; \
	mkdir -p /var/www; \
	
	rm -rf /var/run/session; \
	rm -rf /var/log/anaconda/*; \
	mv -T /etc/freeswitch /src/data/etc; \
	mv -T /var/lib/freeswitch /src/data/lib; \
	mv /var/log /src/data; \
	mv /var/lib/pgsql /src/data; \
	
	ln -s /data/etc /etc/freeswitch; \
	ln -s /data/lib /var/lib/freeswitch; \
	ln -s /data/fusionpbx /var/www/fusionpbx; \
	ln -s /data/log /var/log; \
	ln -s /data/pgsql /var/lib/pgsql; \	
	ln -s /data/cache /var/cache/freeswitch; \	
	ln -s /data/session /var/run/session; \	
	
	cp -f /src/install/supervisor/* /etc/supervisord.d; \
	cp -f /src/install/run.sh /root/run.sh; \
	chmod +x /root/run.sh;
	
	
	
VOLUME ["/data"]
CMD ["/root/run.sh"]
	
