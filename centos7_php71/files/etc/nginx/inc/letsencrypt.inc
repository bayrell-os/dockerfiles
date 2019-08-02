# Let's encrypt
location ~ /.well-known {
	root /var/www/html;
	allow all;
	break;
}