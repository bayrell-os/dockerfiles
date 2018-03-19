#!/bin/bash

cd ~

PGSQL_PASSWORD="pa$$word"


function install {
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	
	echo "Install System"
	cd /
	
	mkdir -p /var/run/dbus
	
	yes | cp -rfT /src/data/freeswitch /data/freeswitch
	yes | cp -rfT /src/data/log /data/log
	yes | cp -rfT /src/data/pgsql /data/pgsql
	
	chown -R freeswitch:daemon /data/freeswitch
	chown -R postgres:postgres /data/pgsql
	
	
	echo "Install Database"
	sudo -u postgres /usr/pgsql-9.4/bin/initdb -D /var/lib/pgsql/9.4/data
	
	echo "Run supervisor"
	/usr/bin/supervisord -c /etc/supervisord.conf
	
	sleep 10
	
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE DATABASE fusionpbx"
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE DATABASE freeswitch"
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$PGSQL_PASSWORD'"
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$PGSQL_PASSWORD'"
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx"
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx"
	sudo -u postgres /usr/pgsql-9.4/bin/psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch"
	
	echo "NO DELETE THIS FILE" > /data/installed.nodelete
	echo "IF THIS FILE DOES NOT EXISTS THE SYSTEM WILL BE REINSTALLED AND ALL DATA LOST" >> /data/installed.nodelete
	echo "" >> /data/installed.nodelete
	echo "Installed in $DATE" >> /data/installed.nodelete
}


function run {
	/usr/bin/supervisord -c /etc/supervisord.conf
}


if [ ! -f /data/installed.nodelete ]; then
	install
else
	run
fi


/bin/bash
