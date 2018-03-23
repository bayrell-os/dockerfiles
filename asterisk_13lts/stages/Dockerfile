FROM bayrell/centos7_repos:latest

ADD install /src/install/


RUN cd ~; \
	echo "[1] Install packages"; \
	yum update -y; \
	yum groupinstall -y core base "Development Tools"; \
	yum install -y mc nano htop supervisor sudo git ca-certificates ntp htop net-tools vim nano openssl wget tar git gcc gcc-c++ make libtool ncurses-devel libtermcap-devel kernel-devel libxml2-devel bzip2 gnutls-devel curl-devel speex-devel gsm-devel sox lame lame-devel lame-libs lame-mp3x doxygen libuuid-devel jansson jansson-devel crontabs; \
	mkdir -p /src/tmp; \
	mkdir -p /data; \
	
	
	echo "[2] Install PHP 5.6"; \
	yum install -y php56 php56-php-gd php56-php-pgsql php56-php-odbc php56-php-imap php56-php-mcrypt php56-php-opcache php56-php-common php56-php-pdo php56-php-soap php56-php-xml php56-php-xmlrpc php56-php-cli php56-php-mysqlnd php56-php-pear php56-php-mbstring php56-php-process php56-php-fpm; \	
	
	sed -i "s|;date.timezone =|date.timezone = Asia/Almaty|g" /etc/opt/remi/php56/php.ini; \
	sed -i 's|;cgi.fix_pathinfo=1|cgi.fix_pathinfo=0|g' /etc/opt/remi/php56/php.ini; \
	sed -i 's|upload_max_filesize =.*|upload_max_filesize = 256M|g' /etc/opt/remi/php56/php.ini; \
	sed -i "s|display_errors =.*|display_errors = On|g" /etc/opt/remi/php56/php.ini; \
	sed -i "s|;open_basedir =.*|open_basedir = none|g" /etc/opt/remi/php56/php.ini; \
	
	sed -i "s|listen = 127.0.0.1:9000|listen = 127.0.0.1:9056|g" /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/;listen.owner = nobody/listen.owner = nobody/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/;listen.group = nobody/listen.group = nobody/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/user = apache/user = asterisk/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's/group = apache/group = asterisk/g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	sed -i 's|php_value\[session.save_path\].*|php_value[session.save_path] = /var/run/session|g' /etc/opt/remi/php56/php-fpm.d/www.conf; \
	
	
	mkdir -p /var/run/session; \
	mkdir -p /var/run/php-fpm; \
	chmod -R 770 /var/run/session; \
	chown asterisk:asterisk /var/run/session; \
	ln -s /usr/bin/php56 /usr/bin/php; \
	ln -s /usr/bin/php56-cli /usr/bin/php-cli; \
	ln -s /usr/bin/php56-cgi /usr/bin/php-cgi; \
	ln -s /opt/remi/php56/root/bin/pear /usr/bin/pear;  \
	
	
	echo "[3] Install Mysql and Apache HTTP Server"; \
	yum -y install lynx mariadb-server mariadb tftp-server httpd ncurses-devel sendmail sendmail-cf sox newt-devel libxml2-devel libtiff-devel audiofile-devel gtk2-devel subversion kernel-devel git crontabs cronie cronie-anacron uuid-devel sqlite-devel net-tools gnutls-devel unixODBC mysql-connector-odbc icu libicu-devel; \
	
	cp -f /src/install/php.conf /etc/httpd/conf.d/; \
	sed -i "s|DirectoryIndex .*|DirectoryIndex index.php index.html|g" /etc/httpd/conf/httpd.conf; \
	sed -i 's|AllowOverride None|AllowOverride All|g' /etc/httpd/conf/httpd.conf; \
	sed -i "s|User apache|User asterisk|g" /etc/httpd/conf/httpd.conf; \
	sed -i "s|Group apache|Group asterisk|g" /etc/httpd/conf/httpd.conf; \
	
	
	
	echo "[4] Configure Asterisk"; \
	mkdir -p cd /src/tmp; \
	cd /src/tmp; \
	mv -v /src/install/download/asterisk-13-current.tar.gz ./; \
	tar xf asterisk-13-current.tar.gz; \
	rm -f asterisk-13-current.tar.gz; \
	cd asterisk-*; \
	./contrib/scripts/install_prereq install; \
	./contrib/scripts/install_prereq install-unpackaged; \
	./contrib/scripts/get_mp3_source.sh; \
	./configure --prefix=/usr --sysconfdir=/etc --without-dahdi --without-pri --without-gtk2 --without-radius --without-x11 --libdir=/usr/lib64 --with-pjproject-bundled; \
	make menuselect.makeopts; \
	
	
	echo "[5] Install Asterisk"; \
	
	cd /src/tmp; \
	cd asterisk-*; \
	./menuselect/menuselect --enable app_mysql --enable cdr_mysql --enable format_mp3 --enable app_mp3 --enable app_saycounted --enable app_sms --enable app_url --enable app_waitforring --enable app_waitforsilence --enable app_ivrdemo --enable res_config_mysql --enable format_jpeg --enable format_vox --enable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-ULAW --enable CORE-SOUNDS-EN-ALAW --enable CORE-SOUNDS-EN-GSM --enable CORE-SOUNDS-EN-G729 --enable CORE-SOUNDS-EN-G722 --enable CORE-SOUNDS-EN-SLN16 --enable CORE-SOUNDS-EN-SIREN7 --enable CORE-SOUNDS-EN-SIREN14 --enable CORE-SOUNDS-RU-WAV --enable CORE-SOUNDS-RU-ULAW --enable CORE-SOUNDS-RU-ALAW --enable CORE-SOUNDS-RU-GSM --enable CORE-SOUNDS-RU-G729 --enable CORE-SOUNDS-RU-G722 --enable CORE-SOUNDS-RU-SLN16 --enable CORE-SOUNDS-RU-SIREN7 --enable CORE-SOUNDS-RU-SIREN14 --enable MOH-OPSOUND-WAV --enable MOH-OPSOUND-ULAW --enable MOH-OPSOUND-ALAW --enable MOH-OPSOUND-GSM --enable MOH-OPSOUND-G729 --enable MOH-OPSOUND-G722 --enable MOH-OPSOUND-SLN16 --enable MOH-OPSOUND-SIREN7 --enable MOH-OPSOUND-SIREN14 --enable EXTRA-SOUNDS-EN-WAV --enable EXTRA-SOUNDS-EN-ULAW --enable EXTRA-SOUNDS-EN-ALAW --enable EXTRA-SOUNDS-EN-GSM --enable EXTRA-SOUNDS-EN-G729 --enable EXTRA-SOUNDS-EN-G722 --enable EXTRA-SOUNDS-EN-SLN16 --enable EXTRA-SOUNDS-EN-SIREN7 --enable EXTRA-SOUNDS-EN-SIREN14; \
	
	make all && make install && make config && make samples && make basic-pbx && make progdocs && make install-logrotate; \
	
	
	useradd -m asterisk; \
	chown asterisk:asterisk /var/run/asterisk; \
	chown -R asterisk:asterisk /etc/asterisk; \
	chown -R asterisk:asterisk /var/{lib,log,spool}/asterisk; \
	chown -R asterisk:asterisk /usr/lib64/asterisk; \
	
	sed -i "s|enabled = no|enabled = yes|g" /etc/asterisk/manager.conf; \
	
	rm -rf /src/tmp/*;  \
	
	
	yes | cp -f /src/install/my.cnf /etc/my.cnf; \
	yes | cp -rfT /src/install/my.cnf.d /etc/my.cnf.d; \
	cp -f /src/install/supervisor/* /etc/supervisord.d; \

	echo "[6] Init database"; \
	/usr/libexec/mariadb-prepare-db-dir; \
	
	
	echo "[7] Run supervisor"; \
	/usr/bin/supervisord -c /etc/supervisord.conf; \	
	sleep 30; \
	mysqladmin -u root create asterisk; \
	mysqladmin -u root create asteriskcdrdb; \
	
	
	echo "[8] Install dependencies"; \
	pear install Console_Getopt; \
	
	
	echo "[9] Install FreePBX"; \
	mkdir -p /var/www/html/admin/modules/pm2/node/logs; \
	chown -R asterisk:asterisk  /var/www/html; \
	mkdir -p /opt; \
	cd /opt; \
	mv /src/install/download/freepbx-13.0-latest.tgz ./; \
	tar xf freepbx-13.0-latest.tgz; \
	cd freepbx;	\
	
	
	cd /opt/freepbx; \
	./start_asterisk start; \
	rm -f /etc/asterisk/asterisk.conf; \
	./install -n; \
	
	supervisorctl stop all;	 \
	
	
	echo "[10] Install folders"; \
	mkdir -p /data; \
	mkdir -p /src/data; \
	mkdir -p /src/data/etc; \
	mkdir -p /src/data/lib; \
	mkdir -p /src/data/spool; \
	mkdir -p /var/run/dbus; \
	
	rm -rf /var/run/session; \
	rm -rf /var/log/anaconda/*; \
	mv -T /etc/asterisk /src/data/etc; \
	mv /var/log /src/data; \
	mv /var/www/html /src/data; \
	mv /var/lib/mysql /src/data; \
	mv -T /var/lib/asterisk /src/data/lib; \
	mv -T /var/spool/asterisk /src/data/spool; \
	mv -f /etc/amportal.conf /src/data; \
	mv -f /etc/odbc.ini /src/data; \
	
	ln -s /data/etc /etc/asterisk; \
	ln -s /data/mysql /var/lib/mysql; \
	ln -s /data/html /var/www/html; \
	ln -s /data/log /var/log; \
	ln -s /data/session /var/run/session; \
	ln -s /data/spool /var/spool/asterisk; \
	ln -s /data/lib /var/lib/asterisk; \
	ln -s /data/amportal.conf /etc/amportal.conf; \
	ln -s /data/odbc.ini /etc/odbc.ini; \
	
	cp -f /src/install/run.sh /root/run.sh; \
	chmod +x /root/run.sh;
	
	
VOLUME ["/data"]
CMD ["/root/run.sh"]		