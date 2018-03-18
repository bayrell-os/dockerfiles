FROM bayrell/centos7_repos:latest


ADD data /src/install/
ADD fusionpbx /var/www/fusionpbx/


RUN cd ~; \
	
	echo "[1] Install common programs"; \
	yum update -y; \
	yum install -y mc nano htop supervisor sudo git ca-certificates ntp htop epel-release vim openssl; \
	yum install -y ghostscript libtiff-devel libtiff-tools at less; \
	yum install -y memcached curl gdb; \
	
	
	
	echo "[2] Install freeswitch"; \
	rpm --import /src/install/download/RPM-GPG-KEY-FREESWITCH; \
	yum install -y /src/install/download/freeswitch-release-1-6.noarch.rpm; \
	yum install -y freeswitch-config-vanilla freeswitch-lang-* freeswitch-sounds-*; 
	
	
	
RUN cd ~; \	
	
	echo "[3] Install Fusion PBX"; \
	rpm -Uvh /src/install/download/cert-forensics-tools-release-el7.rpm; \
	yum install -y lame; \
	find /var/www/fusionpbx -type d -exec chmod 775 {} +; \
	find /var/www/fusionpbx -type f -exec chmod 664 {} +; \
	cd ~; \
	mv /etc/freeswitch /etc/freeswitch.orig; \
	mkdir /etc/freeswitch; \
	cp -R /var/www/fusionpbx/resources/templates/conf/* /etc/freeswitch; \
	
	
	chown -R freeswitch:daemon /etc/freeswitch; \
	chown -R freeswitch:daemon /var/lib/freeswitch; \
	chown -R freeswitch:daemon /usr/share/freeswitch; \
	chown -R freeswitch:daemon /var/log/freeswitch; \
	chown -R freeswitch:daemon /var/run/freeswitch; \
	
	
	
	echo "[4] Install sngrep"; \
	rpm --import /src/install/download/IRONTEC; \
	cp /src/install/irontec.repo > /etc/yum.repos.d/irontec.repo
	yum install -y sngrep;
	
	
	
RUN cd ~; \	
	
	echo "[5] Install PHP 7.1"; \
	yum install -y php71 php71-php-fpm php71-php-gd php71-php-pgsql php71-php-odbc php71-php-imap php71-php-mcrypt php71-php-opcache php71-php-common php71-php-pdo php71-php-soap php71-php-xml php71-php-xmlrpc php71-php-cli; \	
	sed -i "s#;date.timezone =#date.timezone = Asia/Almaty#g" /etc/opt/remi/php71/php.ini; \
	sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/opt/remi/php71/php.ini; \
	sed -i "s|listen = 127.0.0.1:9000|listen = /var/run/php-fpm/php-fpm.sock|g" /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's/;listen.owner = nobody/listen.owner = nobody/g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's/;listen.group = nobody/listen.group = nobody/g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	sed -i 's/group = apache/group = daemon/g' /etc/opt/remi/php71/php-fpm.d/www.conf; \
	mkdir -p /var/opt/remi/php71/lib/php/session; \
	chmod -Rf 770 /var/opt/remi/php71/lib/php/session; \
	ln -s /usr/bin/php71 /usr/bin/php; \
	ln -s /usr/bin/php71-cli /usr/bin/php-cli; \
	ln -s /usr/bin/php71-cgi /usr/bin/php-cgi; \
	
	
	
	echo "[6] Install NGINX"; \	
	yum install -y nginx; \
	cp /src/install/nginx-fusionpbx.conf /etc/nginx/conf.d/fusionpbx.conf; \
	cp -f /src/install/nginx.conf /etc/nginx/nginx.conf; 
	
	
	
RUN cd ~; \	
	
	echo "[7] Install Postgre SQL"; \	
	rpm -Uvh /src/install/download/pgdg-centos94-9.4-3.noarch.rpm; \
	yum -y install postgresql94-server postgresql94-contrib postgresql94; \
	sudo -u postgres ./initdb -D /var/lib/pgsql/9.4/data; 
	
	
	
	echo "[8] Clean yum cache"; \
	yum clean all; \
	rm -rf /var/cache/yum
	
	
	
#RUN cd ~; \
#	
#	echo "[8] Run supervisor"; \
#	mkdir -p /var/run/dbus; \
#	cp -f /src/install/supervisor/* /etc/supervisord.d; \
#	/usr/bin/supervisord -c /etc/supervisord.conf; \
#	
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE DATABASE fusionpbx"; \
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE DATABASE freeswitch"; \
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD 'pa$$word'"; \
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD 'pa$$word'"; \
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx"; \
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx"; \
#	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch"; \
#	
#	
#	
#	
#CMD ["/usr/bin/supervisord -c /etc/supervisord.conf"]

