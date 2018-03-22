#!/bin/bash


MYSQL_PASSWORD="password"
AMPMGRUSER="superadmin"
AMPMGRPASS="password"



function run {
	rm -f /var/run/supervisor/supervisor.sock
	/usr/bin/supervisord -c /etc/supervisord.conf
	sleep 2
	/opt/freepbx/start_asterisk start
	sleep 5
}


function install {
	
	echo "Install System"
	cd /
	
	
	mkdir -p /var/run/dbus
	mkdir -p /data/cache
	mkdir -p /data/mysql
	mkdir -p /data/html
	mkdir -p /data/log
	mkdir -p /data/session
	
	yes | cp -rfT /src/data/etc /data/etc
	yes | cp -rfT /src/data/log /data/log
	yes | cp -rfT /src/data/html /data/html
	yes | cp -rfT /src/data/mysql /data/mysql
	
	
	chown -R mysql:mysql /data/mysql
	chown -R mysql:mysql /data/log/mariadb
	chown -R asterisk:asterisk /data/etc
	chown -R asterisk:asterisk /data/html
	chown -R asterisk:asterisk /data/log/asterisk
	chown -R asterisk:asterisk /data/log/httpd
	chown -R asterisk:asterisk /data/session
	chmod -R 770 /data/session
	
	
	mysql -u root -e "update asterisk.freepbx_settings set value='$AMPMGRUSER' where keyword='AMPMGRUSER';"
	mysql -u root -e "update asterisk.freepbx_settings set value='$AMPMGRPASS' where keyword='AMPMGRPASS';"
	
	#mysql -u root -e "GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
	#mysql -u root -e "GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
	#mysql -u root -e "flush privileges;"
	
	
	sed -i "s|^AMPMGRPASS=.*|AMPMGRPASS=$AMPMGRPASS|g" /etc/amportal.conf
	sed -i "s|^AMPMGRUSER=.*|AMPMGRUSER=$AMPMGRUSER|g" /etc/amportal.conf
	sed -i "s|^;\[mark\]|[$AMPMGRUSER]|g" /etc/asterisk/manager.conf
	sed -i "s|^;secret =.*|secret = $AMPMGRPASS|g" /etc/asterisk/manager.conf
	sed -i "s|^;deny=.*|deny=0.0.0.0/0.0.0.0|g" /etc/asterisk/manager.conf
	sed -i "s|^;permit=.*|permit=127.0.0.1/255.255.255.255|g" /etc/asterisk/manager.conf
	sed -i "s|^;read =.*|read=all|g" /etc/asterisk/manager.conf
	sed -i "s|^;write =.*|write=all|g" /etc/asterisk/manager.conf
	
	
	echo "Run supervisor"
	run
	
	
	echo "NO DELETE THIS FILE" > /data/firstrun.nodelete
	echo "IF THIS FILE DOES NOT EXISTS THE SYSTEM WILL BE REINSTALLED AND ALL DATA LOST" >> /data/firstrun.nodelete
	echo "" >> /data/firstrun.nodelete
	echo "Installed in $DATE" >> /data/firstrun.nodelete
}



if [ ! -f /data/firstrun.nodelete ]; then
	install
else
	run
fi


/bin/bash
