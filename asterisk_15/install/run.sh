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
	mkdir -p /data/session
	
	yes | cp -rfT /src/data/etc /data/etc
	yes | cp -rfT /src/data/log /data/log
	yes | cp -rfT /src/data/html /data/html
	
	
	chown -R mysql:mysql /data/mysql
	chown -R asterisk:asterisk /data/etc
	chown -R asterisk:asterisk /data/html
	chown -R asterisk:asterisk /data/log/asterisk
	chown -R asterisk:asterisk /data/session
	chmod -R 770 /data/session
	
	
	echo "Run supervisor"
	/usr/bin/supervisord -c /etc/supervisord.conf
	
	
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
