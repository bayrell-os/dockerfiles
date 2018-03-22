#!/bin/bash

cd ~

MYSQL_PASSWORD="password"


function install {
	
	
	echo "Install FreePBX"
	mysqladmin -u root create asterisk
	mysqladmin -u root create asteriskcdrdb
	mysql -u root -e "GRANT ALL PRIVILEGES ON asterisk.* TO asteriskuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON asteriskcdrdb.* TO asteriskuser@localhost IDENTIFIED BY '$MYSQL_PASSWORD';"
	mysql -u root -e "flush privileges;"
	#mysql -u root password "'$MYSQL_PASSWORD';"
	
	
	mkdir -p /opt
	cd /opt
	mv /src/install/download/freepbx-14.0-latest.tgz ./
	tar xf freepbx-14.0-latest.tgz
	cd freepbx
	
	
	./start_asterisk start

	mv /etc/asterisk/asterisk.conf /etc/asterisk/asterisk.conf.orig
	./install -n
	
	
	
	#rm -rf /src/tmp/*
	
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	
	echo "NO DELETE THIS FILE" > /data/installfreepbx.nodelete
	echo "IF THIS FILE DOES NOT EXISTS THE SYSTEM WILL BE REINSTALLED AND ALL DATA LOST" >> /data/installfreepbx.nodelete
	echo "" >> /data/installfreepbx.nodelete
	echo "Installed in $DATE" >> /data/installfreepbx.nodelete
}


if [ ! -f /data/installfreepbx.nodelete ]; then
	install
else
	echo "System have been allready installed"
fi