# Deny folders
location ~ /\.cgi.* { deny all; }
location ~ /\.svn.* { deny all; }
location ~ /\.hg.* { deny all; }
location ~ /\.ht.* { deny all; }
location ~ /\.git.* { deny all; }
location ~ /composer.* { deny all; }
location ~ /node_modules.* { deny all; }
location ~ /vendor.* { deny all; }
location ~ \.sql$ { deny all; }	