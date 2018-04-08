#!/bin/bash

cd ~

GATEWAY=10.0.0.100
PSQL_PASSWORD="psqlpassword"
system_username="admin"
system_password="admin"

function install {
	DATE=`date "+%Y-%m-%d %H:%M:%S"`
	
	echo "Install System"
	
	mkdir /data
	cp -arf /src/data/etc /data
	cp -arf /src/data/fusionpbx /data
	cp -arf /src/data/lib /data
	cp -arf /src/data/log /data
	cp -arf /src/data/run /data
	cp -arf /src/data/session /data
	cp -arf /src/data/postgresql /data
	
	cd /tmp
	#sudo -u postgres /usr/pgsql-9.4/bin/initdb -D /var/lib/pgsql/9.4/data
	mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp
	chown -R postgres:postgres /var/run/postgresql/9.4-main.pg_stat_tmp
	
	echo "Run supervisor"
	/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
	
	sleep 10
	
	echo "Create Database"
	sudo -u postgres psql -c "CREATE DATABASE fusionpbx"
	sudo -u postgres psql -c "CREATE DATABASE freeswitch"
	sudo -u postgres psql -c "CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$PSQL_PASSWORD'"
	sudo -u postgres psql -c "CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$PSQL_PASSWORD'"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx"
	sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch"
	sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD '$PSQL_PASSWORD';"
	sudo -u postgres psql -c "ALTER USER freeswitch WITH PASSWORD '$PSQL_PASSWORD';"
	
	
	echo "NO DELETE THIS FILE" > /data/installed.nodelete
	echo "IF THIS FILE DOES NOT EXISTS THE SYSTEM WILL BE REINSTALLED AND ALL DATA LOST" >> /data/installed.nodelete
	echo "" >> /data/installed.nodelete
	echo "Installed in $DATE" >> /data/installed.nodelete
}


function finish {

	cp -f /src/install/config.php /etc/fusionpbx/config.php
	sed -i /etc/fusionpbx/config.php -e s:'{database_username}:fusionpbx:'
	sed -i /etc/fusionpbx/config.php -e s:"{database_password}:$PSQL_PASSWORD:"

	#from https://github.com/fusionpbx/fusionpbx-install.sh/blob/master/centos/resources/finish.sh
	
	#add the database schema
	cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_schema.php > /dev/null 2>&1
	
	#get the ip address
	domain_name=$GATEWAY
	
	#get a domain_uuid
	domain_uuid=$(php /var/www/fusionpbx/resources/uuid.php)
	
	#add the domain name
	sudo -u postgres psql --username=fusionpbx -c "insert into v_domains (domain_uuid, domain_name, domain_enabled) values('$domain_uuid', '$domain_name', 'true');"
	
	#app defaults
	cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_domains.php
	
	#add the user
	user_uuid=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
	user_salt=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
	user_name=$system_username
	user_password=$system_password
	password_hash=$(php -r "echo md5('$user_salt$user_password');");
	sudo -u postgres psql --username=fusionpbx -t -c "insert into v_users (user_uuid, domain_uuid, username, password, salt, user_enabled) values('$user_uuid', '$domain_uuid', '$user_name', '$password_hash', '$user_salt', 'true');"
	
	#get the superadmin group_uuid
	group_uuid=$(psql --username=fusionpbx -t -c "select group_uuid from v_groups where group_name = 'superadmin';");
	group_uuid=$(echo $group_uuid | sed 's/^[[:blank:]]*//;s/[[:blank:]]*$//')
	
	#add the user to the group
	group_user_uuid=$(/usr/bin/php /var/www/fusionpbx/resources/uuid.php);
	group_name=superadmin
	sudo -u postgres psql --username=fusionpbx -c "insert into v_group_users (group_user_uuid, domain_uuid, group_name, group_uuid, user_uuid) values('$group_user_uuid', '$domain_uuid', '$group_name', '$group_uuid', '$user_uuid');"
	
	#update xml_cdr url, user and password
	xml_cdr_username=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
	xml_cdr_password=$(dd if=/dev/urandom bs=1 count=12 2>/dev/null | base64 | sed 's/[=\+//]//g')
	sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_http_protocol}:http:"
	sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{domain_name}:127.0.0.1:"
	sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_project_path}::"
	sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_user}:$xml_cdr_username:"
	sed -i /etc/freeswitch/autoload_configs/xml_cdr.conf.xml -e s:"{v_pass}:$xml_cdr_password:"
	
	#app defaults
	cd /var/www/fusionpbx && php /var/www/fusionpbx/core/upgrade/upgrade_domains.php
	
	supervisorctl restart freeswitch
}


function run {
	mkdir -p /var/run/postgresql/9.4-main.pg_stat_tmp
	chown -R postgres:postgres /var/run/postgresql/9.4-main.pg_stat_tmp
	/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
}


if [ ! -f /data/installed.nodelete ]; then
	install
else
	run
fi


/bin/bash
