#!/bin/bash

cd ~


function install {
	
	echo "Install System"
	cd /
	
	
	mkdir -p /var/run/dbus
	mkdir -p /data/cache
	mkdir -p /data/mysql
	mkdir -p /data/html
	mkdir -p /data/log
	
	yes | cp -rfT /src/data/etc /data/etc
	yes | cp -rfT /src/data/log /data/log
	
	
	echo "Install Mysql"
	/usr/libexec/mariadb-prepare-db-dir

	sleep 5
	
	
	echo "NO DELETE THIS FILE" > /data/firstrun.nodelete
	echo "IF THIS FILE DOES NOT EXISTS THE SYSTEM WILL BE REINSTALLED AND ALL DATA LOST" >> /data/firstrun.nodelete
	echo "" >> /data/firstrun.nodelete
	echo "Installed in $DATE" >> /data/firstrun.nodelete
	echo "Install script manualy. Run install-freepbx"
}


function run {
	/usr/bin/supervisord -c /etc/supervisord.conf
}


if [ ! -f /data/firstrun.nodelete ]; then
	install
else
	run
fi


/bin/bash
