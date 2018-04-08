FROM debian:8


ADD install /src/install/
ADD fusionpbx /var/www/fusionpbx


RUN cd ~; \
	
	export DEBIAN_FRONTEND=noninteractive; \
	echo "[1] Install packages"; \
	apt-get update && apt-get upgrade -y && apt-get install -y lsb-release apt-utils aptitude; \
	apt-get install -y --force-yes ca-certificates wget net-tools sudo ntp curl mc nano htop ssl-cert less gettext vim git ; \
	
	wget http://packages.irontec.com/public.key -q -O - | apt-key add -; \
	wget -O - https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -; \
	echo 'deb http://packages.irontec.com/debian jessie main' > /etc/apt/sources.list.d/sngrep.list; \
	echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list; \
	apt-get update; \
	
	
	echo "[2] Install Freeswitch"; \
	apt-get install -y --force-yes supervisor memcached haveged ghostscript libtiff-tools libtiff5-dev freeswitch-meta-all freeswitch-all freeswitch-all-dbg freeswitch-meta-bare ntp freeswitch-mod-commands freeswitch-mod-console freeswitch-mod-logfile freeswitch-mod-sofia-dbg freeswitch-dbg freeswitch-mod-shout freeswitch-mod-sms-dbg freeswitch-mod-imagick freeswitch-mod-skypopen-dbg freeswitch-music-default gdb libyuv-dev sngrep lame postgresql nginx php5 php5-fpm php5-pgsql apt-transport-https dbus at; \
	
	echo "[3] Setup"; \
	mkdir -p /data; \
	mkdir -p /etc/fusionpbx; \
	rm -f /etc/nginx/nginx.conf; \
	rm -f /etc/nginx/sites-enabled/default; \
	rm -rf /var/log/freeswitch; \
	mkdir /var/log/freeswitch; \
	cp -f /src/install/nginx-fusionpbx.conf /etc/nginx/sites-enabled/fusionpbx.conf; \
	cp -f /src/install/nginx.conf /etc/nginx/nginx.conf; \
	cp -f /src/install/supervisor/* /etc/supervisor/conf.d; \
	mv /etc/freeswitch/ /etc/freeswitch.orig; \
	mkdir /etc/freeswitch/; \
	cp -R /var/www/fusionpbx/resources/templates/conf/* /etc/freeswitch; \
	cp -Rf /var/www/fusionpbx/resources/install/scripts /usr/share/freeswitch; \
	
	chown -R www-data:www-data /etc/freeswitch; \
	chown -R www-data:www-data /usr/share/freeswitch; \
	chown -R www-data:www-data /var/log/freeswitch; \
	chown -R www-data:www-data /var/run/freeswitch; \
	chown -R www-data:www-data /var/lib/freeswitch; \
	chown -R www-data:www-data /etc/fusionpbx; \
	chown -R www-data:www-data /var/www/fusionpbx; \
	chown -R www-data:www-data /var/lib/php5/sessions; \
	chmod 775 /var/log/freeswitch; \
	
	find /var/lib/freeswitch -type d -exec chmod 775 {} +; \
	
	sed -i "s#;date.timezone =#date.timezone = Asia/Almaty#g" /etc/php5/fpm/php.ini; \
	sed -i 's#;session.save_path.*#session.save_path = /var/lib/php5/sessions#g' /etc/php5/fpm/php.ini; \
	
	
	mkdir -p /data/fusionpbx && mv -fT /var/www/fusionpbx /data/fusionpbx && ln -s /data/fusionpbx /var/www/fusionpbx; \
	mkdir -p /data/etc/freeswitch && mv -fT /etc/freeswitch /data/etc/freeswitch && ln -s /data/etc/freeswitch /etc/freeswitch; \
	mkdir -p /data/etc/fusionpbx && mv -fT /etc/fusionpbx /data/etc/fusionpbx && ln -s /data/etc/fusionpbx /etc/fusionpbx; \
	mkdir -p /data/log && mv -fT /var/log/freeswitch /data/log && ln -s /data/log /var/log/freeswitch; \
	mkdir -p /data/run/freeswitch && mv -fT /var/run/freeswitch /data/run/freeswitch && ln -s /data/run/freeswitch /var/run/freeswitch; \
	mkdir -p /data/run/postgresql && mv -fT /var/run/postgresql /data/run/postgresql && ln -s /data/run/postgresql /var/run/postgresql; \
	mkdir -p /data/lib && mv -fT /var/lib/freeswitch /data/lib && ln -s /data/lib /var/lib/freeswitch; \
	mkdir -p /data/session && mv -fT /var/lib/php5/sessions /data/session && ln -s /data/session /var/lib/php5/sessions; \
	mkdir -p /data/postgresql && mv -fT /var/lib/postgresql /data/postgresql && ln -s /data/postgresql /var/lib/postgresql; \
	
	
	mkdir -p /src/data && mv -fT /data /src/data; \
	chmod +x /src/install/run.sh; \
	echo "OK";
	
	
VOLUME ["/data"]
CMD ["/src/install/run.sh"]	
