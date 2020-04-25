if [ ! -d /data/php ]; then
	mkdir -p /data/php
	chown www:www /data/php
fi
if [ ! -d /data/php/session ]; then
	mkdir -p /data/php/session
	chown www:www /data/php/session
fi
if [ ! -d /data/php/wsdlcache ]; then
	mkdir -p /data/php/wsdlcache
	chown www:www /data/php/wsdlcache
fi
