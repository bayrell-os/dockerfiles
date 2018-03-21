#!/bin/bash

cd ~

MYSQL_PASSWORD="password"


function install {
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	
	
	echo "Install Mysql"
	/usr/libexec/mariadb-prepare-db-dir

	sleep 10

	mysqladmin -u root create asterisk
	mysqladmin -u root create asteriskcdrdb
	mysql -u root -e "GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
	mysql -u root -e "flush privileges;"
	#mysql -u root password "'$MYSQL_PASSWORD';"


	echo "Install FreePBX"

	mkdir -p /var/www
	cd /var/www
	mv /src/install/download/freepbx-14.0-latest.tgz ./
	tar xf freepbx-14.0-latest.tgz
	cd freepbx


	./start_asterisk start

	mv /etc/asterisk/asterisk.conf /etc/asterisk/asterisk.conf.orig
	./install -n



	#rm -rf /src/tmp/*


	echo "NO DELETE THIS FILE" > /data/installed.nodelete
	echo "IF THIS FILE DOES NOT EXISTS THE SYSTEM WILL BE REINSTALLED AND ALL DATA LOST" >> /data/installed.nodelete
	echo "" >> /data/installed.nodelete
	echo "Installed in $DATE" >> /data/installed.nodelete
}


if [ ! -f /data/installed.nodelete ]; then
	install
else
	echo "System have been allready installed"
fi