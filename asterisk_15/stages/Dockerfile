FROM bayrell/centos7_repos:latest

ADD install /src/install/


RUN cd ~; \
	
	echo "[1] Install packages"; \
	yum update -y; \
	yum install -y mc nano htop supervisor sudo git ca-certificates ntp htop net-tools vim nano openssl wget tar git ; \
	yum install -y gcc gcc-c++ make libtool ncurses-devel libtermcap-devel kernel-devel libxml2-devel bzip2; \
	yum install -y gnutls-devel curl-devel speex-devel gsm-devel sox lame lame-devel lame-libs lame-mp3x; \
	yum install -y doxygen libuuid-devel jansson jansson-devel man; \
	mkdir -p /src/tmp; \
	mkdir -p /data; 
	
	
RUN cd ~; \

	echo "[2] Install Asterisk"; \
	cd /src/tmp; \
	mv /src/install/download/asterisk-15.3.0.tar.gz ./; \
	tar xf asterisk-15.3.0.tar.gz; \
	cd asterisk-15.3.0; \
	./contrib/scripts/install_prereq install; \
	./contrib/scripts/install_prereq install-unpackaged; \
	./contrib/scripts/get_mp3_source.sh; \
	./configure --prefix=/usr --sysconfdir=/etc --without-dahdi --without-pri --without-gtk2 --without-radius --without-x11 --libdir=/usr/lib64; \
	make menuselect.makeopts; \
	
	
	./menuselect/menuselect --enable app_mysql --enable cdr_mysql --enable format_mp3 --enable res_config_mysql --enable app_setcallerid --enable codec_opus --enable CORE-SOUNDS-EN-WAV --enable CORE-SOUNDS-EN-ULAW --enable CORE-SOUNDS-EN-ALAW --enable CORE-SOUNDS-EN-GSM --enable CORE-SOUNDS-EN-G729 --enable CORE-SOUNDS-EN-G722 --enable CORE-SOUNDS-EN-SLN16 --enable CORE-SOUNDS-EN-SIREN7 --enable CORE-SOUNDS-EN-SIREN14 --enable CORE-SOUNDS-RU-WAV --enable CORE-SOUNDS-RU-ULAW --enable CORE-SOUNDS-RU-ALAW --enable CORE-SOUNDS-RU-GSM --enable CORE-SOUNDS-RU-G722 --enable CORE-SOUNDS-RU-G729 --enable CORE-SOUNDS-RU-SLN16 --enable CORE-SOUNDS-RU-SIREN7 --enable CORE-SOUNDS-RU-SIREN14 --enable MOH-OPSOUND-WAV --enable MOH-OPSOUND-ULAW --enable MOH-OPSOUND-ALAW --enable MOH-OPSOUND-GSM --enable MOH-OPSOUND-G729 --enable MOH-OPSOUND-G722 --enable MOH-OPSOUND-SLN16 --enable MOH-OPSOUND-SIREN7 --enable MOH-OPSOUND-SIREN14 --enable EXTRA-SOUNDS-EN-WAV --enable EXTRA-SOUNDS-EN-ULAW --enable EXTRA-SOUNDS-EN-ALAW --enable EXTRA-SOUNDS-EN-GSM --enable EXTRA-SOUNDS-EN-G729 --enable EXTRA-SOUNDS-EN-G722 --enable EXTRA-SOUNDS-EN-SLN16 --enable EXTRA-SOUNDS-EN-SIREN7 --enable EXTRA-SOUNDS-EN-SIREN14; \
	
	
	make && make install && make config && make samples && make basic-pbx; \
	
	
	useradd -m asterisk; \
	chown asterisk:asterisk /var/run/asterisk; \
	chown -R asterisk:asterisk /etc/asterisk; \
	chown -R asterisk:asterisk /var/{lib,log,spool}/asterisk; \
	chown -R asterisk:asterisk /usr/lib64/asterisk; \
	
	
	rm -rf /src/tmp/*; 
	


RUN cd ~; \

	
	echo "[3] Install PHP 5.6"; \
	yum install -y php56 php56-php-gd php56-php-pgsql php56-php-odbc php56-php-imap php56-php-mcrypt php56-php-opcache php56-php-common php56-php-pdo php56-php-soap php56-php-xml php56-php-xmlrpc php56-php-cli; \	
	
	sed -i "s#;date.timezone =#date.timezone = Asia/Almaty#g" /etc/opt/remi/php56/php.ini; \
	sed -i 's#;cgi.fix_pathinfo=1#cgi.fix_pathinfo=0#g' /etc/opt/remi/php56/php.ini; \
	sed -i 's#upload_max_filesize =.*#upload_max_filesize = 120M#g' /etc/opt/remi/php56/php.ini; \
	sed -i "s#display_errors =.*#display_errors = On#g" /etc/opt/remi/php56/php.ini; \
	sed -i "s#;open_basedir =.*#open_basedir = none#g" /etc/opt/remi/php56/php.ini; \
	
	mkdir -p /var/run/session; \
	mkdir -p /var/run/php-fpm; \
	chmod -R 770 /var/run/session; \
	chown asterisk:asterisk /var/run/session; \
	ln -s /usr/bin/php56 /usr/bin/php; \
	ln -s /usr/bin/php56-cli /usr/bin/php-cli; \
	ln -s /usr/bin/php56-cgi /usr/bin/php-cgi; \
	
	
	echo "[4] Install Mysql and Apache HTTP Server"; \
	yum install -y mariadb httpd mariadb-server;
	
	
	